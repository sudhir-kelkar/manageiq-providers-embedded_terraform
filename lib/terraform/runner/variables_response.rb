require 'json'

module Terraform
  class Runner
    # Response object designed for holding full response from terraform-runner api/template/variables
    class VariablesResponse
      include Vmdb::Logging

      attr_reader :template_input_params, :template_output_params, :terraform_version

      # @return [String] Extracted attributes from the JSON response body object
      def self.parsed_response(http_response)
        data = JSON.parse(http_response.body)
        _log.debug("data : #{data}")
        Terraform::Runner::VariablesResponse.new(
          :template_input_params  => data['template_input_params'],
          :template_output_params => data['template_output_params'],
          :terraform_version      => data['terraform_version']
        )
      end

      def initialize(template_input_params: nil, template_output_params: nil, terraform_version: nil)
        @template_input_params  = template_input_params
        @template_output_params = template_output_params
        @terraform_version      = terraform_version
      end
    end
  end
end
