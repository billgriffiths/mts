require 'spec_helper'

describe "instructors/index" do
  before(:each) do
    assign(:instructors, [
      stub_model(Instructor),
      stub_model(Instructor)
    ])
  end

  it "renders a list of instructors" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
