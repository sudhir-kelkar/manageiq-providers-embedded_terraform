class ServiceTemplateTerraformTemplate < ServiceTemplate
  def self.default_provisioning_entry_point(_service_type)
    '/Service/Generic/StateMachines/GenericLifecycle/provision'
  end

  def self.create_catalog_item(options, _auth_user)
    options      = options.merge(:service_type => SERVICE_TYPE_ATOMIC, :prov_type => 'generic_terraform_template')
    config_info  = validate_config_info(options[:config_info])

    transaction do
      create_from_options(options).tap do |service_template|
        service_template.create_resource_actions(config_info)
      end
    end
  end

  def self.validate_config_info(info)
    return info

    info[:provision][:fqname]   ||= default_provisioning_entry_point(SERVICE_TYPE_ATOMIC) if info.key?(:provision)
    info[:reconfigure][:fqname] ||= default_reconfiguration_entry_point if info.key?(:reconfigure)

    if info.key?(:retirement)
      info[:retirement][:fqname] ||= RETIREMENT_ENTRY_POINTS[info[:retirement][:remove_resources]]
      info[:retirement][:fqname] ||= default_retirement_entry_point
    else
      info[:retirement] = {:fqname => default_retirement_entry_point}
    end

    # TODO: Add more validation for required fields

    info
  end
  private_class_method :validate_config_info

  def terraform_template(action)
    template_id = config_info.dig(action.downcase.to_sym, :configuration_script_payload_id)
    ManageIQ::Providers::EmbeddedTerraform::AutomationManager::Template.find(template_id)
  end
end
