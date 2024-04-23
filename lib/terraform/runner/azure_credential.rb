module Terraform
  class Runner
    class AzureCredential < Credential
      def self.auth_type
        "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::AzureCredential"
      end

      # Modeled off of azure terraform provider:
      #
      #   https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#argument-reference
      #
      # Return connection_parameters as required for terraform_runner
      #
      def connection_parameters
        conn_params = []

        ApiParams.add_param_if_present(conn_params, auth.auth_key, 'ARM_CLIENT_SECRET')

        # TODO: check if we can add more authentication options available in Azure.

        if auth.options
          ApiParams.add_param_if_present(conn_params, auth.options[:client],       'ARM_CLIENT_ID')
          ApiParams.add_param_if_present(conn_params, auth.options[:tenant],       'ARM_TENANT_ID')
          ApiParams.add_param_if_present(conn_params, auth.options[:subscription], 'ARM_SUBSCRIPTION_ID')
        end

        conn_params
      end
    end
  end
end
