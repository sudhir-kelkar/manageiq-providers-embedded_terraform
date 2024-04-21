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

  factory :embedded_terraform_azure_credential,
          :parent => :embedded_terraform_credential,
          :class  => "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::AzureCredential"

  factory :embedded_terraform_google_credential,
          :parent => :embedded_terraform_credential,
          :class  => "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::GoogleCredential"

  factory :embedded_terraform_openstack_credential,
          :parent => :embedded_terraform_credential,
          :class  => "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::OpenstackCredential"
end
