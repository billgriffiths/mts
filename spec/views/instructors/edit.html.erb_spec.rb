require 'spec_helper'

describe "instructors/edit" do
  before(:each) do
    @instructor = assign(:instructor, stub_model(Instructor))
  end

  it "renders the edit instructor form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", instructor_path(@instructor), "post" do
    end
  end
end
