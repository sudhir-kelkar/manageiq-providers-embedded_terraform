require 'terraform/runner'

RSpec.describe(Terraform::Runner::AzureCredential) do
  it ".auth_type is the correct Authentication sub-class" do
    expect(described_class.auth_type).to(eq("ManageIQ::Providers::EmbeddedTerraform::AutomationManager::AzureCredential"))
  end

  context "with a credential object" do
    let(:auth) { FactoryBot.create(:embedded_terraform_azure_credential, auth_attributes) }
    let(:auth_attributes) do
      {
        :auth_key => "client_secret",
        :options  => {
          :client       => "client_id",
          :tenant       => "tenant_id",
          :subscription => "subscription_id"
        }
      }
    end

    let(:cred) { described_class.new(auth.id) }

    # Modeled off of azure terraform provider:
    #
    #   https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#argument-reference
    #
    #
    describe "#connection_parameters" do
      context "client_id and tenant_id present" do
        let(:auth_attributes) do
          {
            :auth_key => "client_secret",
            :options  => {
              :client => "client_id",
              :tenant => "tenant_id"
            }
          }
        end

        it "sets ARM_CLIENT_ID, ARM_TENANT_ID, and ARM_CLIENT_SECRET" do
          expected = [
            {
              'name'    => 'ARM_CLIENT_SECRET',
              'value'   => 'client_secret',
              'secured' => 'false',
            },
            {
              'name'    => 'ARM_CLIENT_ID',
              'value'   => 'client_id',
              'secured' => 'false',
            },
            {
              'name'    => 'ARM_TENANT_ID',
              'value'   => 'tenant_id',
              'secured' => 'false',
            },
          ]
          expect(cred.connection_parameters).to(eq(expected))
        end

        it "does not add ARM_CLIENT_SECRET and ARM_SUBSCRIPTION_ID if missing" do
          auth.update!(:auth_key => nil)
          expected = [
            {
              'name'    => 'ARM_CLIENT_ID',
              'value'   => 'client_id',
              'secured' => 'false',
            },
            {
              'name'    => 'ARM_TENANT_ID',
              'value'   => 'tenant_id',
              'secured' => 'false',
            },
          ]
          expect(cred.connection_parameters).to(eq(expected))
        end

        it "adds ARM_SUBSCRIPTION_ID if present" do
          auth.update!(:options => auth.options.merge(:subscription => "subscription_id"))
          expected = [
            {
              'name'    => 'ARM_CLIENT_SECRET',
              'value'   => 'client_secret',
              'secured' => 'false',
            },
            {
              'name'    => 'ARM_CLIENT_ID',
              'value'   => 'client_id',
              'secured' => 'false',
            },
            {
              'name'    => 'ARM_TENANT_ID',
              'value'   => 'tenant_id',
              'secured' => 'false',
            },
            {
              'name'    => 'ARM_SUBSCRIPTION_ID',
              'value'   => 'subscription_id',
              'secured' => 'false',
            },
          ]
          expect(cred.connection_parameters).to(eq(expected))
        end
      end
    end

    describe "#env_vars" do
      it "returns an empty hash" do
        expect(cred.env_vars).to(eq({}))
      end
    end
  end
end
