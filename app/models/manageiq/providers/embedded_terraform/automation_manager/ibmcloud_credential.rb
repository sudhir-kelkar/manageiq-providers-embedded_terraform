class ManageIQ::Providers::EmbeddedTerraform::AutomationManager::IbmcloudCredential < ManageIQ::Providers::EmbeddedTerraform::AutomationManager::CloudCredential
  COMMON_ATTRIBUTES = [
    {
      :component  => 'password-field',
      :label      => N_('IBM Cloud API Key'),
      :helperText => N_('The API key for IBM Cloud. A value for this field is required if classic user name and classic API key are not provided. A valid connection must have value for IBM Cloud API Key or, IBM Cloud Classic Infrastructure User Name and IBM Cloud Classic Infrastructure API Key.'),
      :name       => 'auth_key',
      :id         => 'auth_key',
      :type       => 'password',
      :isRequired => true,
      :validate   => [{:type => 'required'}],
    },
  ].freeze

  EXTRA_ATTRIBUTES = [
    {
      :component  => 'text-field',
      :label      => N_('IBM Cloud Classic Infrastructure User Name'),
      :helperText => N_('The User Name for IBM Cloud Classic Infrastructure. A value for this field is required when using classic IBM Cloud resources. A valid connection must have value for IBM Cloud API Key or, IBM Cloud Classic Infrastructure User Name and IBM Cloud Classic Infrastructure API Key.'),
      :name       => 'classic_user',
      :id         => 'classic_user',
      :maxLength  => 100,
    },
    {
      :component  => 'password-field',
      :label      => N_('IBM Cloud Classic Infrastructure API Key'),
      :helperText => N_('The API key for IBM Cloud Classic Infrastructure A value for this field is required when using classic IBM Cloud resources. A valid connection must have value for IBM Cloud API Key or, IBM Cloud Classic Infrastructure User Name and IBM Cloud Classic Infrastructure API Key.'),
      :name       => 'classic_key',
      :id         => 'classic_key',
      :type       => 'password',
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

  def self.params_to_attributes(params)
    attrs = super.dup

    attrs[:auth_key] = attrs.delete(:auth_key) if attrs.key?(:auth_key)

    if %i[classic_user classic_key].any? { |opt| attrs.has_key?(opt) }
      attrs[:userid]   = attrs.delete(:classic_user) if attrs.key?(:classic_user)
      attrs[:password] = attrs.delete(:classic_key)  if attrs.key?(:classic_key)
    end

    attrs
  end
end
