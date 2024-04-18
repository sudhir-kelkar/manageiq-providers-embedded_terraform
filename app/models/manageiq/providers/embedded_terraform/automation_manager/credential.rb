class ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Credential < ManageIQ::Providers::EmbeddedAutomationManager::Authentication
  def self.credential_type
    "embedded_terraform_credential_types"
  end
end
