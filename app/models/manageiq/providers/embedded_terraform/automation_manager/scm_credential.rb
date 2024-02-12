class ManageIQ::Providers::EmbeddedTerraform::AutomationManager::ScmCredential < ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Credential
  include ManageIQ::Providers::EmbeddedAutomationManager::ScmCredentialMixin

  FRIENDLY_NAME = "Embedded Terraform SCM Credential".freeze
end
