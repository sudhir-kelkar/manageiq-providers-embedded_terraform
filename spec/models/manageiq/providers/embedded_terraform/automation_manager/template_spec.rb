RSpec.describe ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Template do
  let(:template) { FactoryBot.create(:terraform_template) }

  describe "#run" do
    it "creates a Job" do
      job = template.run
      expect(job).to be_a(ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Job)
    end
  end
end
