# == Schema Information
# Schema version: 11
#
# Table name: test_templates
#
#  id            :integer(11)   not null, primary key
#  name          :string(255)   
#  template      :text          
#  description   :string(255)   
#  course_id     :integer(11)   
#  instructor_id :integer(11)   
#

class TestTemplate < ActiveRecord::Base

  has_and_belongs_to_many  :courses
  belongs_to  :instructor
  has_many    :test_results
  has_many    :answer_records
  
  validates_presence_of   :name, :template
#  validates_presence_of   :description
  
  validates_uniqueness_of :name
  
  def uploaded_test=(test_field)
    self.name       = base_part_of(test_field.original_filename)
    self.template   = test_field.read
  end

  def base_part_of(file_name)
    File.basename(file_name).gsub(/[^\w._-]/, '')
  end
  
  def add_course(course)
    #note: courses should be unique, no duplicates, enforced in add_test_to_course
    courses << course
  end

end
