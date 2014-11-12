require 'spec_helper'

describe "answer_records/show" do
  before(:each) do
    @answer_record = assign(:answer_record, stub_model(AnswerRecord))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
