module Terraform
  class Runner
    class OpenstackCredential < Credential
      def self.auth_type
        "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::OpenstackCredential"
      end

      # Modeled off of openstack terraform provider:
      #
      #   https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs#configuration-reference
      #
      # Return connection_parameters as required for terraform_runner
      #
      def connection_parameters
        conn_params = []

        ApiParams.add_param_if_present(conn_params, auth.host,     'OS_AUTH_URL')
        ApiParams.add_param_if_present(conn_params, auth.userid,   'OS_USERNAME')
        ApiParams.add_param_if_present(conn_params, auth.password, 'OS_PASSWORD')
        ApiParams.add_param_if_present(conn_params, auth.domain,   'OS_DOMAIN_NAME')
        ApiParams.add_param_if_present(conn_params, auth.project,  'OS_TENANT_NAME') # or OS_PROJECT_NAME

        if auth.options
          ApiParams.add_param_if_present(conn_params, auth.options[:region],     'OS_REGION_NAME')
          ApiParams.add_param_if_present(conn_params, auth.options[:cacert],     'OS_CACERT')
          ApiParams.add_param_if_present(conn_params, auth.options[:clientcert], 'OS_CERT')
          ApiParams.add_param_if_present(conn_params, auth.options[:clientkey],  'OS_KEY')
          ApiParams.add_param_if_present(conn_params, auth.options[:insecure],   'OS_INSECURE')
        end

        conn_params
      end
    end
  end
end
