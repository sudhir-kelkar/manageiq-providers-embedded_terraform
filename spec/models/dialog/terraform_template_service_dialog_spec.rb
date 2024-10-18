RSpec.describe Dialog::TerraformTemplateServiceDialog do
  describe "#create_dialog" do
    let(:terraform_template_with_no_input_vars) { nil }

    context "with no template input vars, but with extra vars" do
      it "creates a dialog with extra variables" do
        extra_vars = {
          'some_extra_var'  => {:default => 'blah'},
          'other_extra_var' => {:default => {'name' => 'some_value'}},
          'array_extra_var' => {:default => [{'name' => 'some_value'}]}
        }

        dialog = subject.create_dialog("mydialog1", terraform_template_with_no_input_vars, extra_vars)
        expect(dialog).to have_attributes(:label => 'mydialog1', :buttons => "submit,cancel")

        group = assert_default_tab(dialog)
        assert_extra_variables_group(group)
      end
    end
  end

  context "with no template input vars, nor extra vars" do
    it "creates a dialog with place-holder variable argument, when nil template & empty extra vars" do
      dialog_label = "mydialog2"
      dialog = described_class.create_dialog(dialog_label, nil, {})

      group = assert_default_tab(dialog)
      assert_default_variables_group(group, dialog_label)
    end

    it "creates a dialog with place-holder variable argument, when nil template & nil extra vars" do
      dialog_label = "mydialog3"
      dialog = described_class.create_dialog(dialog_label, nil, nil)

      group = assert_default_tab(dialog)
      assert_default_variables_group(group, dialog_label)
    end
  end

  def assert_default_tab(dialog)
    tabs = dialog.dialog_tabs
    expect(tabs.size).to eq(1)

    tab0 = tabs[0]
    assert_tab_attributes(tab0)

    groups = tab0.dialog_groups
    expect(groups.size).to eq(1)

    groups[0]
  end

  def assert_tab_attributes(tab)
    expect(tab).to have_attributes(:label => "Basic Information", :display => "edit")
  end

  def assert_field(field, clss, attributes)
    expect(field).to be_kind_of clss
    expect(field).to have_attributes(attributes)
  end

  def assert_extra_variables_group(group)
    expect(group).to have_attributes(:label => "Variables", :display => "edit")

    fields = group.dialog_fields
    expect(fields.size).to eq(3)

    assert_field(fields[0], DialogFieldTextBox, :name => 'some_extra_var', :default_value => 'blah', :data_type => 'string')
    assert_field(fields[1], DialogFieldTextBox, :name => 'other_extra_var', :default_value => '{"name":"some_value"}', :data_type => 'string')
    assert_field(fields[2], DialogFieldTextBox, :name => 'array_extra_var', :default_value => '[{"name":"some_value"}]', :data_type => 'string')
  end

  def assert_default_variables_group(group, field_value)
    expect(group).to have_attributes(:label => "Variables", :display => "edit")

    fields = group.dialog_fields
    expect(fields.size).to eq(1)

    assert_field(fields[0], DialogFieldTextBox, :name => 'name', :default_value => field_value, :data_type => 'string')
  end
end
