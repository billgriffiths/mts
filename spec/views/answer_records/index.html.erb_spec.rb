require 'spec_helper'

describe "answer_records/index" do
  before(:each) do
    assign(:answer_records, [
      stub_model(AnswerRecord),
      stub_model(AnswerRecord)
    ])
  end

  it "renders a list of answer_records" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
