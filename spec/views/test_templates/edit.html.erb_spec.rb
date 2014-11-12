require 'spec_helper'

describe "test_templates/edit" do
  before(:each) do
    @test_template = assign(:test_template, stub_model(TestTemplate))
  end

  it "renders the edit test_template form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", test_template_path(@test_template), "post" do
    end
  end
end
