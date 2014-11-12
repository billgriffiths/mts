# == Schema Information
# Schema version: 11
#
# Table name: answer_records
#
#  id               :integer(11)   not null, primary key
#  problem          :string(255)   
#  decoded_answer   :string(255)   
#  start_time       :datetime      
#  test_result_id   :integer(11)   
#  course_id        :integer(11)   
#  test_template_id :integer(11)   
#

#  start_time, course_id, test_template_id are included for convenience, 
#  test_result_id identifies the record that includes these data items.

class AnswerRecord < ActiveRecord::Base
  belongs_to  :course
  belongs_to  :test_template
  belongs_to  :test_result
  
  validates_presence_of   :problem, :decoded_answer, :start_time, :course, :test_template, :test_result
  
end
