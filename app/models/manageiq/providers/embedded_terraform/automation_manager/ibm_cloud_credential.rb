class ManageIQ::Providers::EmbeddedTerraform::AutomationManager::IbmCloudCredential < ManageIQ::Providers::EmbeddedTerraform::AutomationManager::TemplateCredential
  COMMON_ATTRIBUTES = [].freeze

  EXTRA_ATTRIBUTES = [
    {
      :component  => 'password-field',
      :label      => N_('IBM Cloud API Key'),
      :helperText => N_('The API key for IBM Cloud.'),
      :name       => 'auth_key',
      :id         => 'auth_key',
      :type       => 'password',
      :isRequired => true,
      :validate   => [{:type => 'required'}],
    },
  ].freeze

  API_ATTRIBUTES = (COMMON_ATTRIBUTES + EXTRA_ATTRIBUTES).freeze

  API_OPTIONS = {
    :type       => 'cloud',
    :label      => N_('IBM Cloud'),
    :attributes => API_ATTRIBUTES
  }.freeze

  def self.display_name(number = 1)
    n_('Credential (IBM Cloud)', 'Credentials (IBM Cloud)', number)
  end
end
