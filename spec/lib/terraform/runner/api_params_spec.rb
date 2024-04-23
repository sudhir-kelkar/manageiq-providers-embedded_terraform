require 'terraform/runner'

RSpec.describe(Terraform::Runner::ApiParams) do
  it "add param" do
    params = described_class.add_param([], 'param-value', 'PARAM_NAME')
    expect(params)
      .to(eq(
            [
              {
                'name'    => 'PARAM_NAME',
                'value'   => 'param-value',
                'secured' => 'false',
              }
            ]
          ))
  end

  it "add param, with secure true" do
    params = described_class.add_param_if_present([], 'cGFyYW0tdmFsdWUK', 'PARAM_NAME', :is_secured => true)
    expect(params)
      .to(eq(
            [
              {
                'name'    => 'PARAM_NAME',
                'value'   => 'cGFyYW0tdmFsdWUK',
                'secured' => 'true',
              }
            ]
          ))
  end

  it "not adding param, if nil" do
    params = described_class.add_param_if_present([], nil, 'PARAM_NAME')
    expect(params).to(eq([]))
  end

  it "not adding param, if blank" do
    params = described_class.add_param_if_present([], '', 'PARAM_NAME')
    expect(params).to(eq([]))
  end

  it "adding param, if nil" do
    params = described_class.add_param([], nil, 'PARAM_NAME')
    expect(params)
      .to(eq(
            [
              {
                'name'    => 'PARAM_NAME',
                'value'   => nil,
                'secured' => 'false',
              }
            ]
          ))
  end

  it "not adding param, if blank" do
    params = described_class.add_param([], '', 'PARAM_NAME')
    expect(params)
      .to(eq(
            [
              {
                'name'    => 'PARAM_NAME',
                'value'   => '',
                'secured' => 'false',
              }
            ]
          ))
  end

  it "converts to cam_parameters" do
    params = described_class.to_cam_parameters(
      {
        'region'  => 'us-east',
        'vm_name' => 'vm1',
      }
    )
    expect(params)
      .to(eq(
            [
              {
                'name'    => 'region',
                'value'   => 'us-east',
                'secured' => 'false',
              },
              {
                'name'    => 'vm_name',
                'value'   => 'vm1',
                'secured' => 'false',
              },
            ]
          ))
  end
end
