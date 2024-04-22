require 'terraform/runner'

RSpec.describe(Terraform::Runner::IbmcloudCredential) do
  it ".auth_type is the correct Authentication sub-class" do
    expect(described_class.auth_type).to(eq("ManageIQ::Providers::EmbeddedTerraform::AutomationManager::IbmcloudCredential"))
  end

  context "with a credential object" do
    let(:auth) { FactoryBot.create(:embedded_terraform_ibmcloud_credential, auth_attributes) }
    let(:auth_attributes) do
      {
        :auth_key => 'ibmcloud-api-key',
        :userid   => 'iaas-classic-username',
        :password => 'iaas-classic-api-key',
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

      it "adds IAAS_CLASSIC_USERNAME, IAAS_CLASSIC_USERNAME if present" do
        auth.update!(:auth_key => '')
        expected = [
          {
            'name'    => 'IAAS_CLASSIC_USERNAME',
            'value'   => 'iaas-classic-username',
            'secured' => 'false',
          },
          {
            'name'    => 'IAAS_CLASSIC_API_KEY',
            'value'   => 'iaas-classic-api-key',
            'secured' => 'false',
          },
        ]
        expect(cred.connection_parameters).to(eq(expected))
      end
    end

    # describe "#env_vars" do
    #   it "returns an empty hash" do
    #     expect(cred.env_vars).to(eq({}))
    #   end
    # end
  end
end
