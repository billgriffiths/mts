# == Schema Information
# Schema version: 11
#
# Table name: users
#
#  id         :integer(11)   not null, primary key
#  first_name :string(255)   
#  last_name  :string(255)   
#  user_name  :string(255)   
#  password   :string(255)   
#  role       :string(255)   
#

class User < ActiveRecord::Base
  
  has_secure_password
  
  ROLE_TYPES = [
    # Displayed     stored in db
    ["staff",         "staff"],
    ["administrator", "administrator"],
    ["instructor",    "instructor"]
  ]
  
  validates_presence_of   :first_name, :last_name, :user_name, :password, :role
  
  validates_uniqueness_of :user_name
  
  attr_accessor :password_confirmation

  validates_confirmation_of :password
  validates_inclusion_of :role, :in => ROLE_TYPES.map {|disp, value| value}
  
  
end
