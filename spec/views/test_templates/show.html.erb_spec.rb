require 'spec_helper'

describe "test_templates/show" do
  before(:each) do
    @test_template = assign(:test_template, stub_model(TestTemplate))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
