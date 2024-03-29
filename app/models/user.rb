# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base 
  attr_accessible :name, :email, :password, :password_confirmation
  has_secure_password
  before_save{|user| user.email=email.downcase}
  email_regex= /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates(:name, presence: true, length: {maximum: 32})
   validates(:email, presence: true, format: {with: email_regex}, uniqueness: {case_sensitive: false} )
   validates :password, presence: true, length: {minimum: 6}
   validates :password_confirmation, presence: true
end
