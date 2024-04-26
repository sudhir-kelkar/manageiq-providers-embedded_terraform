class ManageIQ::Providers::EmbeddedTerraform::AutomationManager::OpenstackCredential < ManageIQ::Providers::EmbeddedTerraform::AutomationManager::CloudCredential
  COMMON_ATTRIBUTES = [
    {
      :component  => 'text-field',
      :label      => N_('Username'),
      :helperText => N_('The username to use to connect to OpenStack'),
      :name       => 'userid',
      :id         => 'userid',
      :isRequired => true,
      :validate   => [{:type => 'required'}],
    },
    {
      :component  => 'password-field',
      :label      => N_('Password (API Key)'),
      :helperText => N_('The password or API key to use to connect to OpenStack'),
      :name       => 'password',
      :id         => 'password',
      :type       => 'password',
      :isRequired => true,
      :validate   => [{:type => 'required'}],
    },
  ].freeze

  EXTRA_ATTRIBUTES = [
    {
      :component  => 'text-field',
      :label      => N_('Host (Authentication URL)'),
      :helperText => N_('The host to authenticate with. For example, https://openstack.business.com/v2.0'),
      :name       => 'host',
      :id         => 'host',
      :maxLength  => 1024,
      :isRequired => true,
      :validate   => [{:type => 'required'}],
    },
    {
      :component  => 'text-field',
      :label      => N_('Project (Tenant Name)'),
      :helperText => N_('This is the tenant name. This value is usually the same as the username'),
      :name       => 'project',
      :id         => 'project',
      :maxLength  => 100,
      :isRequired => true,
      :validate   => [{:type => 'required'}],
    },
    {
      :component  => 'text-field',
      :label      => N_('Domain Name'),
      :helperText => N_('OpenStack domains define administrative boundaries. It is only needed for Keystone v3 authentication URLs'),
      :name       => 'domain',
      :id         => 'domain',
      :maxLength  => 100,
    },
    {
      :component  => 'text-field',
      :label      => N_('Region Name'),
      :helperText => N_('The region to create resources on'),
      :name       => 'region',
      :id         => 'region',
      :maxLength  => 100,
    },
    {
      :component      => 'password-field',
      :label          => N_('CA certificate'),
      :helperText     => N_('The custom CA certificate when communicating over SSL'),
      :componentClass => 'textarea',
      :name           => 'cacert',
      :id             => 'cacert',
      :type           => 'password',
    },
    {
      :component      => 'password-field',
      :label          => N_('Client Certificate'),
      :helperText     => N_('The client certificate for SSL client authentication.'),
      :componentClass => 'textarea',
      :name           => 'clientcert',
      :id             => 'clientcert',
      :type           => 'password',
    },
    {
      :component  => 'checkbox',
      :label      => N_('Trust self-signed SSL certificates ?'),
      :helperText => N_('Trust self-signed SSL certificates ?'),
      :name       => 'insecure',
      :id         => 'insecure',
    },
  ].freeze

  API_ATTRIBUTES = (COMMON_ATTRIBUTES + EXTRA_ATTRIBUTES).freeze

  API_OPTIONS = {
    :type       => 'cloud',
    :label      => N_('OpenStack'),
    :attributes => API_ATTRIBUTES
  }.freeze

  def self.display_name(number = 1)
    n_('Credential (OpenStack)', 'Credentials (OpenStack)', number)
  end

  def self.params_to_attributes(params)
    attrs = super.dup

    if %i[host domain project region cacert clientcert clientkey insecure].any? { |opt| attrs.key?(opt) }
      attrs[:options]         ||= {}
      attrs[:options][:host]    = attrs.delete(:host)    if attrs.key?(:host)
      attrs[:options][:domain]  = attrs.delete(:domain)  if attrs.key?(:domain)
      attrs[:options][:project] = attrs.delete(:project) if attrs.key?(:project)
      attrs[:options][:region]  = attrs.delete(:region)  if attrs.key?(:region)

      attrs[:options][:cacert]     = attrs.delete(:cacert)     if attrs.key?(:cacert)
      attrs[:options][:clientcert] = attrs.delete(:clientcert) if attrs.key?(:clientcert)
      attrs[:options][:clientkey]  = attrs.delete(:clientkey)  if attrs.key?(:clientkey)

      attrs[:options][:insecure] = attrs.delete(:insecure) if attrs.key?(:insecure)
    end

    attrs
  end

  def host
    options && options[:host]
  end

  def domain
    options && options[:domain]
  end

  def project
    options && options[:project]
  end
end
