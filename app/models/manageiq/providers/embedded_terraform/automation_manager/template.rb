class ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Template < ManageIQ::Providers::EmbeddedAutomationManager::ConfigurationScriptPayload
  has_many :stacks, :class_name => "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Stack", :foreign_key => :configuration_script_base_id, :inverse_of => :configuration_script_payload, :dependent => :nullify

  def run(options = {}, _userid = nil)
    self.class.module_parent::Job.create_job(options).tap(&:signal_start)
  end
end
