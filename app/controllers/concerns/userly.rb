module Userly
    extend ActiveSupport::Concern  
    
    #redirects to user login page if user is not logged in
  def authenticate_user
#    save current page for redirection after login
      redirect_to controller: :user, action: :login unless logged_in? 
      current_user
  end
  
# logs the user into the server  
  def login_user(user)
    session[:current_user_id] = user.id
  end
  
  def logout_user
        session[:current_user_id] = nil
        @current_user = nil
  end
  
  def logged_in?
    !session[:current_user_id].nil?
  end  
  
#  returns an object for the current user
  def current_user
    @current_user ||= User.find_by(id: session[:current_user_id])
  end
  
#  validates and returns a user object using username and password
  def valid_user?(username, password)
    user_obj = User.find_by(username: username).try(:authenticate, password)
    if !user_obj 
      raise 'Username or password is invalid'
    end
    user_obj
  end
  
end
