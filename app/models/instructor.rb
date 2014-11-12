# == Schema Information
# Schema version: 11
#
# Table name: instructors
#
#  id         :integer(11)   not null, primary key
#  first_name :string(255)   
#  last_name  :string(255)   
#

class Instructor < ActiveRecord::Base

  has_many  :courses
  has_many  :test_templates

  validates_presence_of   :first_name, :last_name
  validates_uniqueness_of :first_name, :scope => 'last_name'
  
  def whole_name
    last_name+", "+first_name 
  end

  def add_course(course)
    #note: courses should be unique, no duplicates, enforced in add_course
    courses << course
  end
  
end
