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

        if auth.host
          conn_params.push(
            {
              'name'    => 'OS_AUTH_URL',
              'value'   => auth.host,
              'secured' => 'false',
            }
          )
        end

        if auth.userid
          conn_params.push(
            {
              'name'    => 'OS_USERNAME',
              'value'   => auth.userid,
              'secured' => 'false',
            }
          )
        end

        if auth.password
          conn_params.push(
            {
              'name'    => 'OS_PASSWORD',
              'value'   => auth.password,
              'secured' => 'false',
            }
          )
        end

        if auth.domain
          conn_params.push(
            {
              'name'    => 'OS_DOMAIN_NAME',
              'value'   => auth.domain,
              'secured' => 'false',
            }
          )
        end

        if auth.project
          conn_params.push(
            {
              'name'    => 'OS_TENANT_NAME', # or OS_PROJECT_NAME
              'value'   => auth.project,
              'secured' => 'false',
            }
          )
        end

        if auth.options
          if auth.options[:region].present?
            conn_params.push(
              {
                'name'    => 'OS_REGION_NAME',
                'value'   => auth.options[:region],
                'secured' => 'false',
              }
            )
          end
          if auth.options[:cacert].present?
            conn_params.push(
              {
                'name'    => 'OS_CACERT',
                'value'   => auth.options[:cacert],
                'secured' => 'false',
              }
            )
          end
          if auth.options[:clientcert].present?
            conn_params.push(
              {
                'name'    => 'OS_CERT',
                'value'   => auth.options[:clientcert],
                'secured' => 'false',
              }
            )
          end
          if auth.options[:clientkey].present?
            conn_params.push(
              {
                'name'    => 'OS_KEY',
                'value'   => auth.options[:clientkey],
                'secured' => 'false',
              }
            )
          end
          if auth.options[:insecure].present?
            conn_params.push(
              {
                'name'    => 'OS_INSECURE',
                'value'   => auth.options[:insecure],
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
