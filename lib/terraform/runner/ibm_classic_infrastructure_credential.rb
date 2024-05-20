module Terraform
  class Runner
    class IbmClassicInfrastructureCredential < Credential
      def self.auth_type
        "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::IbmClassicInfrastructureCredential"
      end

      # Modeled off of IBM Cloud provider for terraform:
      #
      #   https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs#environment-variables
      #
      # Return connection_parameters as required for terraform_runner
      #
      def connection_parameters
        conn_params = []

        ApiParams.add_param_if_present(conn_params, auth.userid,   'IAAS_CLASSIC_USERNAME')
        ApiParams.add_param_if_present(conn_params, auth.password, 'IAAS_CLASSIC_API_KEY')

        conn_params
      end
    end
  end
end
