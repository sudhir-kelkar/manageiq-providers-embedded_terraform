RSpec.describe Dialog::TerraformTemplateServiceDialog do
  describe "#create_dialog" do
    context "with no template input vars, but with extra vars" do
      let(:terraform_template_with_no_input_vars) { nil }

      it "creates a dialog with extra variables" do
        extra_vars = {
          'some_extra_var'  => {:default => 'blah'},
          'other_extra_var' => {:default => {'name' => 'some_value'}},
          'array_extra_var' => {:default => [{'name' => 'some_value'}]}
        }

        dialog = subject.create_dialog("mydialog1", terraform_template_with_no_input_vars, extra_vars)
        expect(dialog).to have_attributes(:label => 'mydialog1', :buttons => "submit,cancel")

        tabs = dialog.dialog_tabs
        expect(tabs.size).to eq(1)

        tab0 = tabs[0]
        assert_tab_attributes(tab0)

        groups = tab0.dialog_groups
        expect(groups.size).to eq(1)

        assert_extra_variables_group(groups[0])
      end

      it "creates a dialog with no extra variables" do
        dialog = described_class.create_dialog("mydialog2", terraform_template_with_no_input_vars, {})
        expect(dialog.dialog_tabs[0].dialog_groups.size).to eq(1)
      end
    end
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
end
