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

        if auth.userid
          conn_params.push(
            {
              'name'    => 'AWS_ACCESS_KEY_ID',
              'value'   => auth.userid,
              'secured' => 'false',
            }
          )
        end

        if auth.password
          conn_params.push(
            {
              'name'    => 'AWS_SECRET_ACCESS_KEY',
              'value'   => auth.password,
              'secured' => 'false',
            }
          )
        end

        if auth.auth_key
          conn_params.push(
            {
              'name'    => 'AWS_SESSION_TOKEN',
              'value'   => auth.auth_key,
              'secured' => 'false',
            }
          )
        end

        # TODO: check if this region, is correct value for AWS region
        if auth.region_id
          region = MiqRegion.find_by(:region => auth.region_id).name
          conn_params.push(
            {
              'name'    => 'AWS_REGION',
              'value'   => region,
              'secured' => 'false',
            }
          )
        end

        conn_params
      end
    end
  end
end
