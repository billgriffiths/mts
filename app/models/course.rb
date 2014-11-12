# == Schema Information
# Schema version: 11
#
# Table name: courses
#
#  id            :integer(11)   not null, primary key
#  course_name   :string(255)   
#  class_number :string(255)   
#  instructor_id :integer(11)   
#

#  class_number is the unique identifier. It should
#  actually be called class_number as it distinguishes classes.
#  course_name should depend on it.

class Course < ActiveRecord::Base
  
  belongs_to  :instructor
  has_and_belongs_to_many    :test_templates
  has_many    :answer_records
  
  has_and_belongs_to_many  :students

  validates_presence_of :course_name, :class_number
  
  validates_uniqueness_of :class_number
  
  attr_reader :title
  
  def title
    "#{course_name}  #{class_number}"
  end
  
  def add_test(test_template)
    test_templates <<  test_template
  end

end
