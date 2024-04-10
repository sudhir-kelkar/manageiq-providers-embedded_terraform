RSpec.describe ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Job do
  let(:job)   { described_class.create_job(options).tap { |job| job.state = state} }
  let(:state) { "waiting_to_start" }
  let(:options) { {} }

  describe ".create_job" do
    it "create a job" do
      options = {}

      expect(described_class.create_job(options)).to have_attributes(
        :type    => "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Job",
        :options => options
      )
    end
  end

  describe "#signal" do
    %w[start poll_runner finish abort_job cancel error].each do |signal|
      shared_examples_for "allows #{signal} signal" do
        it signal.to_s do
          expect(job).to receive(signal.to_sym)
          job.signal(signal.to_sym)
        end
      end
    end

    %w[start poll_runner post_execute].each do |signal|
      shared_examples_for "doesn't allow #{signal} signal" do
        it signal.to_s do
          expect { job.signal(signal.to_sym) }.to raise_error(RuntimeError, /#{signal} is not permitted at state #{job.state}/)
        end
      end
    end

    context "waiting_to_start" do
      let(:state) { "waiting_to_start" }

      it_behaves_like "allows start signal"
      it_behaves_like "allows finish signal"
      it_behaves_like "allows abort_job signal"
      it_behaves_like "allows cancel signal"
      it_behaves_like "allows error signal"
      it_behaves_like "doesn't allow poll_runner signal"
    end

    context "running" do
      let(:state) { "running" }

      it_behaves_like "doesn't allow start signal"
      it_behaves_like "allows finish signal"
      it_behaves_like "allows abort_job signal"
      it_behaves_like "allows cancel signal"
      it_behaves_like "allows error signal"
      it_behaves_like "allows poll_runner signal"
    end

    context "finished" do
      let(:state) { "finished" }

      it_behaves_like "doesn't allow start signal"
      it_behaves_like "doesn't allow poll_runner signal"
      it_behaves_like "allows finish signal"
      it_behaves_like "allows abort_job signal"
      it_behaves_like "allows cancel signal"
      it_behaves_like "allows error signal"
    end
  end

  describe "#start" do
    it "moves to state running" do
      job.signal(:start)
      expect(job.reload.state).to eq("running")
    end
  end

  describe "#poll_runner" do
    let(:state) { "running" }

    context "still running" do
      before { expect(job).to receive(:running?).and_return(true) }
    end

    context "completed" do
      it "moves to state finished" do
        job.signal(:poll_runner)
        expect(job.reload.state).to eq("finished")
      end
    end
  end
end
