# == Schema Information
# Schema version: 11
#
# Table name: test_results
#
#  id               :integer(11)   not null, primary key
#  answers          :string(255)   
#  test_items       :text          
#  score            :float         
#  status           :string(255)   
#  start_time       :datetime      
#  student_id       :integer(11)   
#  course_id        :integer(11)   
#  test_template_id :integer(11)   
#

class TestResult < ActiveRecord::Base

  belongs_to  :student
  belongs_to  :course
  belongs_to  :test_template
  has_many    :answer_records

  validates_presence_of   :status, :start_time, :student_id, :course_id, :test_template_id

end
