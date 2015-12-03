class User < ActiveRecord::Base
  validates :username, length: {minimum:2}, uniqueness: true, presence: true
  validates :password_digest, length: {minimum:6}, presence: true
  validates :email, uniqueness: true, presence: true
  validates :firstname, presence: true, allow_blank: true
  validates :surname, presence: true, allow_blank: true
  validates :token, presence: true, allow_blank: true
  validates :timeout, presence: true, allow_blank: true
  has_secure_password
  
#  define static (class) methods
  class << self
    
  def valid_user?(username, password)
    user_obj = self.find_by(username: username).try(:authenticate, password)
    if !user_obj 
      raise 'Username or password is invalid'
    end
    user_obj.id
  end
  
  end

  
end
