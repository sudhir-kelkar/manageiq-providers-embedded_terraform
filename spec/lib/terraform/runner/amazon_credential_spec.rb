require 'terraform/runner'

RSpec.describe(Terraform::Runner::AmazonCredential) do
  it ".auth_type is the correct Authentication sub-class" do
    expect(described_class.auth_type).to(eq("ManageIQ::Providers::EmbeddedTerraform::AutomationManager::AmazonCredential"))
  end

  context "with a credential object" do
    let(:auth) { FactoryBot.create(:embedded_terraform_amazon_credential, auth_attributes) }
    let(:auth_attributes) do
      {
        :userid   => "manageiq-aws",
        :password => "aws_secret",
        :auth_key => "key_data",
        :options  => {}
      }
    end

    let(:cred) { described_class.new(auth.id) }

    # Modeled off of aws provider for terraform:
    #
    #   https://registry.terraform.io/providers/hashicorp/aws/latest/docs#aws-configuration-reference
    #
    describe "#env_vars" do
      it "sets AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY" do
        auth.update!(:auth_key => nil)
        expected = [
          {
            'name'    => 'AWS_ACCESS_KEY_ID',
            'value'   => 'manageiq-aws',
            'secured' => 'false',
          },
          {
            'name'    => 'AWS_SECRET_ACCESS_KEY',
            'value'   => 'aws_secret',
            'secured' => 'false',
          },
        ]
        expect(cred.connection_parameters).to(eq(expected))
      end

      it "not added AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY if blank" do
        auth.update!(:userid => nil, :password => nil, :auth_key => nil)
        expected = []
        expect(cred.connection_parameters).to(eq(expected))
      end

      it "adds AWS_SECURITY_TOKEN if present" do
        expected = [
          {
            'name'    => 'AWS_ACCESS_KEY_ID',
            'value'   => 'manageiq-aws',
            'secured' => 'false',
          },
          {
            'name'    => 'AWS_SECRET_ACCESS_KEY',
            'value'   => 'aws_secret',
            'secured' => 'false',
          },
          {
            'name'    => 'AWS_SESSION_TOKEN',
            'value'   => 'key_data',
            'secured' => 'false',
          },
        ]
        expect(cred.connection_parameters).to(eq(expected))
      end

      it "adds AWS_REGION if present" do
        auth.update!(:options => auth.options.merge(:region => "aws_region"))

        expected = [
          {
            'name'    => 'AWS_ACCESS_KEY_ID',
            'value'   => 'manageiq-aws',
            'secured' => 'false',
          },
          {
            'name'    => 'AWS_SECRET_ACCESS_KEY',
            'value'   => 'aws_secret',
            'secured' => 'false',
          },
          {
            'name'    => 'AWS_SESSION_TOKEN',
            'value'   => 'key_data',
            'secured' => 'false',
          },
          {
            'name'    => 'AWS_REGION',
            'value'   => 'aws_region',
            'secured' => 'false',
          },
        ]
        expect(cred.connection_parameters).to(eq(expected))
      end
    end

    describe "#env_vars" do
      it "returns an empty hash" do
        expect(cred.env_vars).to(eq({}))
      end
    end
  end
end
