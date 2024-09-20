class Dialog
  class TerraformTemplateServiceDialog
    def self.create_dialog(label, extra_vars)
      new.create_dialog(label, extra_vars)
    end

    # This dialog is to be used by a terraform template service item
    def create_dialog(label, extra_vars)
      Dialog.new(:label => label, :buttons => "submit,cancel").tap do |dialog|
        tab = dialog.dialog_tabs.build(:display => "edit", :label => "Basic Information", :position => 0)
        if extra_vars.present?
          add_variables_group(tab, 1, extra_vars)
        end
        dialog.save!
      end
    end

    private

    def add_variables_group(tab, position, extra_vars)
      tab.dialog_groups.build(
        :display  => "edit",
        :label    => "Variables",
        :position => position
      ).tap do |dialog_group|
        extra_vars.transform_values { |val| val[:default] }.each_with_index do |(key, value), index|
          value = value.to_json if [Hash, Array].include?(value.class)
          add_variable_field(key, value, dialog_group, index)
        end
      end
    end

    def add_variable_field(key, value, group, position)
      group.dialog_fields.build(
        :type           => "DialogFieldTextBox",
        :name           => "param_#{key}",
        :data_type      => "string",
        :display        => "edit",
        :required       => false,
        :default_value  => value,
        :label          => key,
        :description    => key,
        :reconfigurable => true,
        :position       => position,
        :dialog_group   => group,
        :read_only      => false
      )
    end
  end
end
