class User < ActiveRecord::Base
  validates :username, length: {minimum:2}, uniqueness: true, presence: true
  validates :password, length: {minimum:6}, presence: true
  validates :email, uniqueness: true, presence: true
  validates :firstname, allow_blank: true
  validates :surname, allow_blank: true
  validates :token, allow_blank: true
  validates :timeout, allow_blank: true
end
