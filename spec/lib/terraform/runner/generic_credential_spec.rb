require 'terraform/runner'

RSpec.describe(Terraform::Runner::GenericCredential) do
  it ".auth_type is an empty string" do
    expect(described_class.auth_type).to(eq(""))
  end

  context "with a credential object" do
    let(:cred) do
      auth = FactoryBot.create(:authentication)
      described_class.new(auth.id)
    end

    it "#connection_parameters is an empty array" do
      expect(cred.connection_parameters).to(eq([]))
    end

    it "#env_vars is an empty hash" do
      expect(cred.env_vars).to(eq({}))
    end
  end
end
