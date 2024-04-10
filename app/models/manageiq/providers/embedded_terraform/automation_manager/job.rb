class ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Job < Job
  def start
    queue_signal(:poll_runner)
  end

  def poll_runner
    if finished?
      signal(:finish)
    else
      queue_signal(:poll_runner, :deliver_on => Time.now.utc + poll_interval)
    end
  end

  alias initializing dispatch_start
  alias finish       process_finished
  alias abort_job    process_abort
  alias cancel       process_cancel
  alias error        process_error

  protected

  def finished?
    true
  end

  def load_transitions
    self.state ||= 'initialize'

    {
      :initializing => {'initialize'       => 'waiting_to_start'},
      :start        => {'waiting_to_start' => 'running'},
      :poll_runner  => {'running'          => 'running'},
      :finish       => {'*'                => 'finished'},
      :abort_job    => {'*'                => 'aborting'},
      :cancel       => {'*'                => 'canceling'},
      :error        => {'*'                => '*'}
    }
  end

  def poll_interval
    options.fetch(:poll_interval, 1.minute).to_i
  end
end
