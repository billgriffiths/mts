require 'spec_helper'

describe "test_templates/index" do
  before(:each) do
    assign(:test_templates, [
      stub_model(TestTemplate),
      stub_model(TestTemplate)
    ])
  end

  it "renders a list of test_templates" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
