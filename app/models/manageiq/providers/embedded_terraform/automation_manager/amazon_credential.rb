class ManageIQ::Providers::EmbeddedTerraform::AutomationManager::AmazonCredential < ManageIQ::Providers::EmbeddedTerraform::AutomationManager::CloudCredential
  COMMON_ATTRIBUTES = [
    {
      :component  => 'text-field',
      :label      => N_('Access Key'),
      :helperText => N_('AWS Access Key for this credential'),
      :name       => 'userid',
      :id         => 'userid',
      :isRequired => true,
      :validate   => [{:type => 'required'}],
    },
    {
      :component  => 'password-field',
      :label      => N_('Secret Key'),
      :helperText => N_('AWS Secret Key for this credential'),
      :name       => 'password',
      :id         => 'password',
      :type       => 'password',
      :isRequired => true,
      :validate   => [{:type => 'required'}],
    },
  ].freeze

  EXTRA_ATTRIBUTES = [
    {
      :component  => 'password-field',
      :label      => N_('STS Token'),
      :helperText => N_('Security Token Service(STS) Token for this credential'),
      :name       => 'security_token',
      :id         => 'security_token',
      :type       => 'password',
      :maxLength  => 1024
    },
    {
      :component  => 'text-field',
      :label      => N_('AWS Region'),
      :helperText => N_('AWS Region where the provider will operate. The Region must be set.'),
      :name       => 'region',
      :id         => 'region',
      :isRequired => true,
      :maxLength  => 50,
    },
  ].freeze

  API_ATTRIBUTES = (COMMON_ATTRIBUTES + EXTRA_ATTRIBUTES).freeze

  API_OPTIONS = {
    :type       => 'cloud',
    :label      => N_('Amazon'),
    :attributes => API_ATTRIBUTES
  }.freeze

  alias security_token auth_key

  def self.display_name(number = 1)
    n_('Credential (Amazon)', 'Credentials (Amazon)', number)
  end

  def self.params_to_attributes(params)
    attrs = super.dup
    attrs[:auth_key] = attrs.delete(:security_token) if attrs.key?(:security_token)
    if %i[region].any? { |opt| attrs.key?(opt) }
      attrs[:options] ||= {}
      attrs[:options][:region] = attrs.delete(:region) if attrs.key?(:region)
    end
    attrs
  end
end
