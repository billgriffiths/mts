require 'spec_helper'

describe "instructors/show" do
  before(:each) do
    @instructor = assign(:instructor, stub_model(Instructor))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
