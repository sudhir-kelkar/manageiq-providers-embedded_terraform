module Terraform
  class Runner
    class AmazonCredential < Credential
      def self.auth_type
        "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::AmazonCredential"
      end

      # Modeled off of aws provider for terraform:
      #
      #   https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
      #
      # Return connection_parameters as required for terraform_runner
      #
      def connection_parameters
        conn_params = []

        ApiParams.add_param_if_present(conn_params, auth.userid,   'AWS_ACCESS_KEY_ID')
        ApiParams.add_param_if_present(conn_params, auth.password, 'AWS_SECRET_ACCESS_KEY')
        ApiParams.add_param_if_present(conn_params, auth.auth_key, 'AWS_SESSION_TOKEN')

        if auth.options
          ApiParams.add_param_if_present(conn_params, auth.options[:region], 'AWS_REGION')
        end

        conn_params
      end
    end
  end
end
