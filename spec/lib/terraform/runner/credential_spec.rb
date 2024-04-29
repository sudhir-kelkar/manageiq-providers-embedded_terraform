RSpec.describe(Terraform::Runner::Credential) do
  describe ".new" do
    it "initializes a GenericCredential when given a missing auth_type" do
      auth = FactoryBot.create(:authentication)
      cred = described_class.new(auth.id)
      expect(cred).to(be_an_instance_of(Terraform::Runner::GenericCredential))
    end

    it "initializes a VsphereCredential for ManageIQ::Providers::EmbeddedTerraform::AutomationManager::VsphereCredential" do
      auth = FactoryBot.create(:embedded_terraform_vsphere_credential)
      cred = described_class.new(auth.id)
      expect(cred).to(be_an_instance_of(Terraform::Runner::VsphereCredential))
    end

    it "initializes attributes" do
      auth = FactoryBot.create(:authentication)
      cred = described_class.new(auth.id)
      expect(cred.auth.id).to(eq(auth.id))
    end
  end
end
