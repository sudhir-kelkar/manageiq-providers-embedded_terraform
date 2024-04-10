FactoryBot.define do
  factory :terraform_template,
          :class  => "ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Template",
          :parent => :configuration_script_payload
end
