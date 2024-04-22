module Terraform
  class Runner
    class IbmcloudCredential < Credential
      def self.auth_type
        "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::IbmcloudCredential"
      end

      # Modeled off of IBM Cloud provider for terraform:
      #
      #   https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs#environment-variables
      #
      # Return connection_parameters as required for terraform_runner
      #
      def connection_parameters
        conn_params = []

        if auth.auth_key.present?
          conn_params.push(
            {
              'name'    => 'IC_API_KEY',
              'value'   => auth.auth_key,
              'secured' => 'false',
            }
          )
        end

        if auth.userid.present?
          conn_params.push(
            {
              'name'    => 'IAAS_CLASSIC_USERNAME',
              'value'   => auth.userid,
              'secured' => 'false',
            }
          )
        end
        if auth.password.present?
          conn_params.push(
            {
              'name'    => 'IAAS_CLASSIC_API_KEY',
              'value'   => auth.password,
              'secured' => 'false',
            }
          )
        end

        conn_params
      end
    end
  end
end
