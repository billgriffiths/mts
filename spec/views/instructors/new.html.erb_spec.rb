require 'spec_helper'

describe "instructors/new" do
  before(:each) do
    assign(:instructor, stub_model(Instructor).as_new_record)
  end

  it "renders new instructor form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", instructors_path, "post" do
    end
  end
end
