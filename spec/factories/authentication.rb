FactoryBot.define do
  factory :embedded_terraform_credential,
          :parent => :embedded_automation_manager_authentication,
          :class  => "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Credential"

  factory :embedded_terraform_scm_credential,
          :parent => :embedded_terraform_credential,
          :class  => "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::ScmCredential"

  factory :embedded_terraform_vsphere_credential,
          :parent => :embedded_terraform_credential,
          :class  => "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::VsphereCredential"

  factory :embedded_terraform_amazon_credential,
          :parent => :embedded_terraform_credential,
          :class  => "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::AmazonCredential"
end
