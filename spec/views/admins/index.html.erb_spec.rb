require 'spec_helper'

describe "admins/index" do
  before(:each) do
    assign(:admins, [
      stub_model(Admin),
      stub_model(Admin)
    ])
  end

  it "renders a list of admins" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
