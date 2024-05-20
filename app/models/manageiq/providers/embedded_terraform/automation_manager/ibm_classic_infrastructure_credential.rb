class ManageIQ::Providers::EmbeddedTerraform::AutomationManager::IbmClassicInfrastructureCredential < ManageIQ::Providers::EmbeddedTerraform::AutomationManager::TemplateCredential
  COMMON_ATTRIBUTES = [].freeze

  EXTRA_ATTRIBUTES = [
    {
      :component  => 'text-field',
      :label      => N_('IBM Cloud Classic Infrastructure User Name'),
      :helperText => N_('The User Name for IBM Cloud Classic Infrastructure.'),
      :name       => 'userid',
      :id         => 'userid',
      :maxLength  => 100,
      :isRequired => true,
      :validate   => [{:type => 'required'}],
    },
    {
      :component  => 'password-field',
      :label      => N_('IBM Cloud Classic Infrastructure API Key'),
      :helperText => N_('The API key for IBM Cloud Classic Infrastructure.'),
      :name       => 'password',
      :id         => 'password',
      :type       => 'password',
      :isRequired => true,
      :validate   => [{:type => 'required'}],
    },
  ].freeze

  API_ATTRIBUTES = (COMMON_ATTRIBUTES + EXTRA_ATTRIBUTES).freeze

  API_OPTIONS = {
    :type       => 'cloud',
    :label      => N_('IBM Cloud Classic Infrastructure'),
    :attributes => API_ATTRIBUTES
  }.freeze

  def self.display_name(number = 1)
    n_('Credential (IBM Cloud Classic Infrastructure)', 'Credentials (IBM Cloud Classic Infrastructure)', number)
  end
end
