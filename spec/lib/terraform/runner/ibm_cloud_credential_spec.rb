require 'terraform/runner'

RSpec.describe(Terraform::Runner::IbmCloudCredential) do
  it ".auth_type is the correct Authentication sub-class" do
    expect(described_class.auth_type).to(eq("ManageIQ::Providers::EmbeddedTerraform::AutomationManager::IbmCloudCredential"))
  end

  context "with a credential object" do
    let(:auth) { FactoryBot.create(:embedded_terraform_ibm_cloud_credential, auth_attributes) }
    let(:auth_attributes) do
      {
        :auth_key => 'ibmcloud-api-key',
      }
    end

    let(:cred) { described_class.new(auth.id) }

    # Modeled off of IBM Cloud provider for terraform:
    #
    #   https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs#environment-variables
    #
    describe "#connection_parameters" do
      it "sets IC_API_KEY" do
        auth.update!(:userid => '', :password => '')
        expected = [
          {
            'name'    => 'IC_API_KEY',
            'value'   => 'ibmcloud-api-key',
            'secured' => 'false',
          },
        ]
        expect(cred.connection_parameters).to(eq(expected))
      end
    end
  end
end
