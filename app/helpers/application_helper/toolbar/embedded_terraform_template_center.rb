class ApplicationHelper::Toolbar::EmbeddedTerraformTemplateCenter < ApplicationHelper::Toolbar::Basic
  button_group('embedded_terraform_templates_policy', [
                 select(
                   :embedded_terraform_template_configuration,
                   nil,
                   t = N_('Configuration'),
                   t,
                   :items => [
                     button(
                       :embedded_configuration_script_payload_map_credentials,
                       'pficon pficon-edit fa-lg',
                       t = N_('Map Credentials to this Template'),
                       t,
                       :klass => ApplicationHelper::Button::EmbeddedTerraform,
                       :url   => "/map_credentials"
                     ),
                   ]
                 ),
                 select(
                   :embedded_terraform_templates_policy_choice,
                   nil,
                   t = N_('Policy'),
                   t,
                   :items => [
                     button(
                       :embedded_configuration_script_payload_tag,
                       'pficon pficon-edit fa-lg',
                       N_('Edit Tags for this Template'),
                       N_('Edit Tags')
                     ),
                   ]
                 )
               ])
end
