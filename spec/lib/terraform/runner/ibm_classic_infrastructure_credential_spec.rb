require 'terraform/runner'

RSpec.describe(Terraform::Runner::IbmClassicInfrastructureCredential) do
  it ".auth_type is the correct Authentication sub-class" do
    expect(described_class.auth_type).to(eq("ManageIQ::Providers::EmbeddedTerraform::AutomationManager::IbmClassicInfrastructureCredential"))
  end

  context "with a credential object" do
    let(:auth) { FactoryBot.create(:embedded_terraform_ibm_classic_infrastructure_credential, auth_attributes) }
    let(:auth_attributes) do
      {
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
  end
end
