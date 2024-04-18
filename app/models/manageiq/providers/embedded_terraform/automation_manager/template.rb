class ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Template < ManageIQ::Providers::EmbeddedAutomationManager::ConfigurationScriptPayload
  has_many :stacks, :class_name => "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Stack", :foreign_key => :configuration_script_base_id, :inverse_of => :configuration_script_payload, :dependent => :nullify

  def run(input_vars = {}, _userid = nil)
    env_vars = {}
    credentials = []

    self.class.module_parent::Job.create_job(self, env_vars, input_vars, credentials).tap(&:signal_start)
  end
end
