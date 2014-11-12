require 'spec_helper'

describe "answer_records/edit" do
  before(:each) do
    @answer_record = assign(:answer_record, stub_model(AnswerRecord))
  end

  it "renders the edit answer_record form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", answer_record_path(@answer_record), "post" do
    end
  end
end
