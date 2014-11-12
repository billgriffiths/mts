# == Schema Information
# Schema version: 11
#
# Table name: students
#
#  id             :integer(11)   not null, primary key
#  first_name     :string(255)   
#  last_name      :string(255)   
#  student_number :string(255)   
#

class Student < ActiveRecord::Base

  has_many  :test_results
  
  has_and_belongs_to_many  :courses

  validates_presence_of   :first_name, :last_name, :student_number
  
  validates_format_of     :student_number, :with => /\AL\d{9}\z/
  
  validates_uniqueness_of :student_number
  
  def add_course(course)
    #note: courses should be unique, no duplicates, enforced in add_student_to_course
    courses << course
  end

  def add_test_result(test_result)
    @test_result = TestResult.find(test_result)
    test_results << @test_result
  end
end
