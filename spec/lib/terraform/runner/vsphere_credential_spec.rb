require 'terraform/runner'

RSpec.describe(Terraform::Runner::VsphereCredential) do
  it ".auth_type is the correct Authentication sub-class" do
    expect(described_class.auth_type).to(eq("ManageIQ::Providers::EmbeddedTerraform::AutomationManager::VsphereCredential"))
  end

  context "with a credential object" do
    let(:auth) { FactoryBot.create(:embedded_terraform_vsphere_credential, auth_attributes) }
    let(:auth_attributes) do
      {
        :userid   => "manageiq-vmware",
        :password => "vmware_secret",
        :options  => {
          :host => "vmware_host",
          # :allow_unverified_ssl => false,
          # :vim_keep_alive       => 30,
        },
      }
    end

    let(:cred) { described_class.new(auth.id) }

    # Modeled off of VMware vSphere provider arguments:
    #
    #   https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs#argument-reference
    #
    #
    describe "#env_vars" do
      it "sets VSPHERE_USER, VSPHERE_PASSWORD, and VSPHERE_SERVER" do
        expected = [
          {
            'name'    => 'VSPHERE_USER',
            'value'   => 'manageiq-vmware',
            'secured' => 'false',
          },
          {
            'name'    => 'VSPHERE_PASSWORD',
            'value'   => 'vmware_secret',
            'secured' => 'false',
          },
          {
            'name'    => 'VSPHERE_SERVER',
            'value'   => 'vmware_host',
            'secured' => 'false',
          },
        ]
        expect(cred.connection_parameters).to(eq(expected))
      end

      it "defaults VSPHERE_USER, VSPHERE_PASSWORD, and VSPHERE_SERVER to '' if missing" do
        auth.update!(:userid => nil, :password => nil, :options => nil)
        expected = [
          {
            'name'    => 'VSPHERE_USER',
            'value'   => '',
            'secured' => 'false',
          },
          {
            'name'    => 'VSPHERE_PASSWORD',
            'value'   => '',
            'secured' => 'false',
          },
          {
            'name'    => 'VSPHERE_SERVER',
            'value'   => '',
            'secured' => 'false',
          },
        ]
        expect(cred.connection_parameters).to(eq(expected))
      end

      it "handles empty options hash" do
        auth.update!(:options => {})
        expected = [
          {
            'name'    => 'VSPHERE_USER',
            'value'   => 'manageiq-vmware',
            'secured' => 'false',
          },
          {
            'name'    => 'VSPHERE_PASSWORD',
            'value'   => 'vmware_secret',
            'secured' => 'false',
          },
          {
            'name'    => 'VSPHERE_SERVER',
            'value'   => '',
            'secured' => 'false',
          },
        ]
        expect(cred.connection_parameters).to(eq(expected))
      end
    end
  end
end
