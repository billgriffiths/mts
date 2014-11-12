require 'spec_helper'

describe "answer_records/new" do
  before(:each) do
    assign(:answer_record, stub_model(AnswerRecord).as_new_record)
  end

  it "renders new answer_record form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", answer_records_path, "post" do
    end
  end
end
