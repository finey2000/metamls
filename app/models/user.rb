class User < ActiveRecord::Base
  validates :username, length: {minimum:2}, uniqueness: true, presence: true
  validates :password_digest, length: {minimum:6}, presence: true
  validates :email, uniqueness: true, presence: true, :email_format => {:message => 'Invalid email'}
  validates :firstname, presence: true, allow_blank: true
  validates :surname, presence: true, allow_blank: true
  validates :token, presence: true, allow_blank: true
  validates :timeout, presence: true, allow_blank: true
  has_secure_password
  
  has_many :bookmarks, {inverse_of: :user, dependent: :destroy} #linked to bookmarks, destroy bookmarks if user is deleted
  has_many :properties, through: :bookmarks
  
  
end
