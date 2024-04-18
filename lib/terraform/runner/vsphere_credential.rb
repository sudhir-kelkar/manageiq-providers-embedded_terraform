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
        [
          {
            'name'    => 'VSPHERE_USER',
            'value'   => auth.userid || '',
            'secured' => 'false',
          },
          {
            'name'    => 'VSPHERE_PASSWORD',
            'value'   => auth.password || '',
            'secured' => 'false',
          },
          {
            'name'    => 'VSPHERE_SERVER',
            'value'   => auth.host || '',
            'secured' => 'false',
          },
        ]
        # 'VSPHERE_ALLOW_UNVERIFIED_SSL' => auth.allow_unverified_ssl || Nil,
        # 'VSPHERE_VIM_KEEP_ALIVE'       => auth.vim_keep_alive || Nil,
      end
    end
  end
end
