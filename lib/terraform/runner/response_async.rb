module Terraform
  class Runner
    class ResponseAsync
      include Vmdb::Logging

      attr_reader :response, :debug

      # Response object designed for holding full response from terraform-runner
      #
      # @param response [Object] Terraform::Runner::Response object
      # @param debug [Boolean] whether or not to delete base_dir after run (for debugging)
      def initialize(response, debug: false)
        @response = response
        @debug    = debug
      end

      # @return [Boolean] true if the terraform job is still running, false when it's finished
      def running?
        response.status == "IN_PROGRESS"
      end

      # Stops the running Terraform job
      def stop
        raise NotImplementedError, "Not yet impleted"
      end
    end
  end
end
