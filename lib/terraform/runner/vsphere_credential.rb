module Terraform
  class Runner
    class VsphereCredential < Credential
      def self.auth_type
        'ManageIQ::Providers::EmbeddedTerraform::AutomationManager::VsphereCredential'
      end

      # Modeled off of VMware vSphere provider arguments:
      #
      #   https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs#argument-reference
      #
      # Returns connection_parameters as required by terraform_runner
      #
      def connection_parameters
        conn_params = []

        ApiParams.add_param_if_present(conn_params, auth.userid,   'VSPHERE_USER')
        ApiParams.add_param_if_present(conn_params, auth.password, 'VSPHERE_PASSWORD')
        ApiParams.add_param_if_present(conn_params, auth.host,     'VSPHERE_SERVER')

        # 'VSPHERE_ALLOW_UNVERIFIED_SSL' => auth.options[:allow_unverified_ssl] || Nil,
        # 'VSPHERE_VIM_KEEP_ALIVE'       => auth.options[:vim_keep_alive] || Nil,

        conn_params
      end
    end
  end
end
