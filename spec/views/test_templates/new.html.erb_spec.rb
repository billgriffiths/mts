require 'spec_helper'

describe "test_templates/new" do
  before(:each) do
    assign(:test_template, stub_model(TestTemplate).as_new_record)
  end

  it "renders new test_template form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", test_templates_path, "post" do
    end
  end
end
