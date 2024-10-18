RSpec.describe ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Stack do
  describe "#raw_status" do
    let(:stack) { FactoryBot.create(:terraform_stack, :miq_task => miq_task) }

    context "with a running deployment" do
      let(:miq_task) { FactoryBot.create(:miq_task, :state => "Running", :status => "Ok", :message => "process initiated") }

      it "returns a status that is running" do
        expect(stack.raw_status.completed?).to be_falsey
      end
    end

    context "with a successful deployment" do
      let(:miq_task) { FactoryBot.create(:miq_task, :state => "Finished", :status => "Ok", :message => "Task completed successfully") }

      it "returns a status that is completed" do
        expect(stack.raw_status.completed?).to be_truthy
      end
    end

    context "with a failed deployment" do
      let(:miq_task) { FactoryBot.create(:miq_task, :state => "Finished", :status => "Error", :message => "Failed to run template") }

      it "returns a status that is failed" do
        expect(stack.raw_status.failed?).to be_truthy
      end

      it "returns a normalized_status with a reason" do
        expect(stack.raw_status.normalized_status).to eq(["failed", "Failed to run template"])
      end
    end
  end

  describe "#raw_stdout" do
    let(:stack) { FactoryBot.create(:terraform_stack) }
    let(:template) { FactoryBot.create(:terraform_template) }

    shared_examples_for "terraform runner stdout not available from miq_task" do
      it "json" do
        expect(stack.raw_stdout("json")).to eq("")
      end

      it "txt" do
        expect(stack.raw_stdout("txt")).to eq ""
      end

      it "html" do
        expect(stack.raw_stdout("html")).to include <<~EOHTML
          <div class='term-container'>
          No output available
          </div>
        EOHTML
      end

      it "nil" do
        expect(stack.raw_stdout).to eq ""
      end
    end

    context "when miq_task is missing" do
      before do
        stack.miq_task = nil
      end

      it_behaves_like "terraform runner stdout not available from miq_task"
    end

    context "when miq_task present, but missing miq_task.job" do
      before do
        stack.miq_task = FactoryBot.create(:miq_task)
        stack.miq_task.job = nil
      end

      it_behaves_like "terraform runner stdout not available from miq_task"
    end

    context "when miq_task.job.options present but missing terraform_stack_id" do
      before do
        stack.miq_task = FactoryBot.create(:miq_task)
        stack.miq_task.job = ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Job.create_job(template, {}, {}, []).tap do |job|
          job.state = "waiting_to_start"
          job.options = {}
        end
      end

      it_behaves_like "terraform runner stdout not available from miq_task"
    end
  end
end
