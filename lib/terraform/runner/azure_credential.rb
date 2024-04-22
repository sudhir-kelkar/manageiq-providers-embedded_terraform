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

        if auth.auth_key.present?
          conn_params.push(
            {
              'name'    => 'ARM_CLIENT_SECRET',
              'value'   => auth.auth_key,
              'secured' => 'false',
            }
          )
        end

        # TODO: check if we can add more authentication options

        if auth.options
          if auth.options[:client].present?
            conn_params.push(
              {
                'name'    => 'ARM_CLIENT_ID',
                'value'   => auth.options[:client],
                'secured' => 'false',
              }
            )
          end
          if auth.options[:tenant].present?
            conn_params.push(
              {
                'name'    => 'ARM_TENANT_ID',
                'value'   => auth.options[:tenant],
                'secured' => 'false',
              }
            )
          end
          if auth.options[:subscription].present?
            conn_params.push(
              {
                'name'    => 'ARM_SUBSCRIPTION_ID',
                'value'   => auth.options[:subscription],
                'secured' => 'false',
              }
            )
          end
        end

        conn_params
      end
    end
  end
end
