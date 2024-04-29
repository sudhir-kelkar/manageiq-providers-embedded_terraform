class ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Credential < ManageIQ::Providers::EmbeddedAutomationManager::Authentication
  def self.credential_type
    "embedded_terraform_credential_types"
  end

  FRIENDLY_NAME = "Embedded Terraform Credential".freeze

  private_class_method def self.queue_role
    "embedded_terraform"
  end
end
