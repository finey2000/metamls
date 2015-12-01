class User < ActiveRecord::Base
  validates :username, length: {minimum:2}, uniqueness: true, presence: true
  validates :password, length: {minimum:6}, presence: true
  validates :email, uniqueness: true, presence: true
  validates :firstname, presence: true, allow_blank: true
  validates :surname, presence: true, allow_blank: true
  validates :token, presence: true, allow_blank: true
  validates :timeout, presence: true, allow_blank: true
end
