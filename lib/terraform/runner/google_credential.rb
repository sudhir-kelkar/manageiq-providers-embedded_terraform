module Terraform
  class Runner
    class GoogleCredential < Credential
      def self.auth_type
        "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::GoogleCredential"
      end

      # Modeled off of gce teraform provider:
      #
      #   https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference
      #
      # Return connection_parameters as required for terraform_runner
      #
      def connection_parameters
        conn_params = [
          {
            'name'    => 'GOOGLE_CREDENTIALS',
            'value'   => gce_credentials_json,
            'secured' => 'false',
          }
        ]

        if auth.project.present?
          conn_params.push(
            {
              'name'    => 'GOOGLE_PROJECT',
              'value'   => auth.project,
              'secured' => 'false',
            }
          )
        end

        if auth.options && auth.options[:region].present?
          conn_params.push(
            {
              'name'    => 'GOOGLE_REGION',
              'value'   => auth.options[:region],
              'secured' => 'false',
            }
          )
        end

        conn_params
      end

      private

      def gce_credentials_json
        json_data = {
          :type                        => 'service_account',
          :private_key                 => auth.auth_key || "",
          :client_email                => auth.userid || "",
          :project_id                  => auth.project || "",
          :auth_uri                    => 'https://accounts.google.com/o/oauth2/auth',
          :token_uri                   => 'https://oauth2.googleapis.com/token',
          :auth_provider_x509_cert_url => 'https://www.googleapis.com/oauth2/v1/certs'
        }

        if auth.userid.present?
          client_x509_cert_url = "https://www.googleapis.com/robot/v1/metadata/x509/#{CGI.escape(auth.userid)}"
          json_data[:client_x509_cert_url] = client_x509_cert_url
        end

        json_data.to_json
      end
    end
  end
end
