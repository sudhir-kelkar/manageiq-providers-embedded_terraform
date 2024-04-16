require 'faraday'
require 'timeout'
require 'tempfile'
require 'zip'
require 'base64'

module Terraform
  class Runner
    class << self
      def available?
        return @available if defined?(@available)

        response = terraform_runner_client.get('api/terraformjobs/count')
        @available = response.status == 200
      rescue
        @available = false
      end

      # Run a template, initiates terraform-runner job for running a template, via terraform-runner api
      #
      # @param input_vars [Hash] Hash with key/value pairs that will be passed as input variables to the
      #        terraform-runner run
      # @param template_path [String] Path to the template we will want to run
      # @param tags [Hash] Hash with key/values pairs that will be passed as tags to the terraform-runner run
      # @param credentials [Array] List of Authentication object ids to provide to the terraform run
      # @param env_vars [Hash] Hash with key/value pairs that will be passed as environment variables to the
      #        terraform-runner run
      # @return [Terraform::Runner::ResponseAsync] Response object of terraform-runner create action
      def run_async(input_vars, template_path, tags: nil, credentials: [], env_vars: {})
        _log.debug("Run_aysnc template: #{template_path}")
        response = create_stack_job(
          template_path,
          :input_vars  => input_vars,
          :tags        => tags,
          :credentials => credentials,
          :env_vars    => env_vars
        )
        Terraform::Runner::ResponseAsync.new(response.stack_id)
      end

      # Stop running terraform-runner job by stack_id
      #
      # @param stack_id [String] stack_id from the terraforn-runner job
      #
      # @return [Terraform::Runner::Response] Response object with result of terraform run
      def stop_async(stack_id)
        cancel_stack_job(stack_id)
      end

      # Runs a template, waits until it terraform-runner job completes, via terraform-runner api
      #
      # @param input_vars [Hash] Hash with key/value pairs that will be passed as input variables to the
      #        terraform-runner run
      # @param template_path [String] Path to the template we will want to run
      # @param tags [Hash] Hash with key/values pairs that will be passed as tags to the terraform-runner run
      # @param credentials [Array] List of Authentication object ids to provide to the terraform run
      # @param env_vars [Hash] Hash with key/value pairs that will be passed as environment variables to the
      #        terraform-runner run
      # @return [Terraform::Runner::Response] Response object with final result of terraform run
      def run(input_vars, template_path, tags: nil, credentials: [], env_vars: {})
        _log.debug("Run template: #{template_path}")
        create_stack_job_and_wait_until_completes(
          template_path,
          :input_vars  => input_vars,
          :tags        => tags,
          :credentials => credentials,
          :env_vars    => env_vars
        )
      end

      # Fetch terraform-runner job result/status by stack_id
      #
      # @param stack_id [String] stack_id from the terraforn-runner job
      #
      # @return [Terraform::Runner::Response] Response object with result of terraform run
      def fetch_result_by_stack_id(stack_id)
        retrieve_stack_job(stack_id)
      end

      # =================================================
      # TerraformRunner Stack-API interaction methods
      # =================================================
      private

      def server_url
        ENV.fetch('TERRAFORM_RUNNER_URL', 'https://opentofu-runner:27000')
      end

      def server_token
        ENV.fetch('TERRAFORM_RUNNER_TOKEN', nil)
      end

      def stack_job_interval_in_secs
        ENV.fetch('TERRAFORM_RUNNER_STACK_JOB_CHECK_INTERVAL', 10).to_i
      end

      def stack_job_max_time_in_secs
        ENV.fetch('TERRAFORM_RUNNER_STACK_JOB_MAX_TIME', 120).to_i
      end

      # Create to paramaters as used by terraform-runner api
      #
      # @param vars [Hash] Hash with key/value pairs that will be passed as input variables to the
      #        terraform-runner run
      # @return [Array] Array of {:name,:value}
      def convert_to_cam_parameters(vars)
        return [] if vars.nil?

        vars.map do |key, value|
          {
            :name  => key,
            :value => value
          }
        end
      end

      # create http client for terraform-runner rest-api
      def terraform_runner_client
        @terraform_runner_client ||= begin
          # TODO: verify ssl
          verify_ssl = false

          Faraday.new(
            :url => server_url,
            :ssl => {:verify => verify_ssl}
          ) do |builder|
            builder.request(:authorization, 'Bearer', -> { server_token })
          end
        end
      end

      def stack_tenant_id
        '00000000-0000-0000-0000-000000000000'.freeze
      end

      # Create TerraformRunner Stack Job
      def create_stack_job(
        template_path,
        input_vars: [],
        tags: nil,
        credentials: [],
        env_vars: {},
        name: "stack-#{rand(36**8).to_s(36)}"
      )
        _log.info("start stack_job for template: #{template_path}")
        tenant_id = stack_tenant_id
        encoded_zip_file = encoded_zip_from_directory(template_path)

        # TODO: use tags,env_vars
        payload = JSON.generate(
          {
            :cloud_providers => credentials,
            :name            => name,
            :tenantId        => tenant_id,
            :templateZipFile => encoded_zip_file,
            :parameters      => convert_to_cam_parameters(input_vars)
          }
        )
        # _log.debug("Payload:>\n, #{payload}")
        http_response = terraform_runner_client.post(
          "api/stack/create",
          payload,
          "Content-Type" => "application/json"
        )
        _log.debug("==== http_response.body: \n #{http_response.body}")
        _log.info("stack_job for template: #{template_path} running ...")
        Terraform::Runner::Response.parsed_response(http_response)
      end

      # Retrieve TerraformRunner Stack Job details
      def retrieve_stack_job(stack_id)
        payload = JSON.generate({:stack_id => stack_id})
        http_response = terraform_runner_client.post(
          "api/stack/retrieve",
          payload,
          "Content-Type" => "application/json"
        )
        _log.info("==== Retrieve Stack Response: \n #{http_response.body}")
        Terraform::Runner::Response.parsed_response(http_response)
      end

      # Cancel/Stop running TerraformRunner Stack Job
      def cancel_stack_job(stack_id)
        payload = JSON.generate({:stack_id => stack_id})
        http_response = terraform_runner_client.post(
          "api/stack/cancel",
          payload,
          "Content-Type" => "application/json"
        )
        _log.info("==== Cancel Stack Response: \n #{http_response.body}")
        Terraform::Runner::Response.parsed_response(http_response)
      end

      # Wait for TerraformRunner Stack Job to complete
      def wait_until_completes(stack_id)
        interval_in_secs = stack_job_interval_in_secs
        max_time_in_secs = stack_job_max_time_in_secs

        response = nil
        Timeout.timeout(max_time_in_secs) do
          _log.debug("Starting wait for terraform-runner/stack/#{stack_id} completes ...")
          i = 0
          loop do
            _log.debug("loop #{i}")
            i += 1

            response = retrieve_stack_job(stack_id)

            _log.info("status: #{response.status}")

            case response.status
            when "SUCCESS"
              _log.debug("Successful! (stack_job/:#{stack_id})")
              break

            when "FAILED"
              _log.info("Failed! (stack_job/:#{stack_id} fails!)")
              _log.info(response.error_message)
              break

            when nil
              _log.info("No status! stack_job/:#{stack_id} must have failed, check response ...")
              _log.info(response.message)
              break
            end
            _log.info("============\n stack_job/:#{stack_id} status=#{response.status} \n============")

            # sleep interval
            _log.debug("Sleep for #{interval_in_secs} secs")
            sleep interval_in_secs

            break if i >= 20
          end
          _log.debug("loop ends: ran #{i} times")
        end
        response
      end

      # Create TerraformRunner Stack Job, wait until completes
      def create_stack_job_and_wait_until_completes(
        template_path,
        input_vars: [],
        tags: nil,
        credentials: [],
        env_vars: {},
        name: "stack-#{rand(36**8).to_s(36)}"
      )
        _log.info("create_stack_job_and_wait_until_completes for #{template_path}")
        response = create_stack_job(
          template_path,
          :input_vars  => input_vars,
          :tags        => tags,
          :credentials => credentials,
          :env_vars    => env_vars,
          :name        => name
        )
        wait_until_completes(response.stack_id)
      end

      # encode zip of a template directory
      def encoded_zip_from_directory(template_path)
        dir_path = template_path # directory to be zipped
        dir_path = path[0...-1] if dir_path.end_with?('/')

        Tempfile.create(%w[opentofu-runner-payload .zip]) do |zip_file_path|
          _log.debug("Create #{zip_file_path}")
          Zip::File.open(zip_file_path, Zip::File::CREATE) do |zipfile|
            Dir.chdir(dir_path)
            Dir.glob("**/*").select { |fn| File.file?(fn) }.each do |file|
              _log.debug("Adding #{file}")
              zipfile.add(file.sub("#{dir_path}/", ''), file)
            end
          end
          Base64.encode64(File.binread(zip_file_path))
        end
      end
    end
  end
end
