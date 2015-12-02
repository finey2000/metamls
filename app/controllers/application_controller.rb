class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  #redirects to user login page if user is not logged in
  def current_user
    user_id = session[:current_user_id]
    if !user_id 
      return redirect_to controller: :user, action: :login 
    end
    
    @_current_user = User.find_by(id: user_id)
    
    if !@_current_user 
      redirect_to controller: :user, action: :login
    end
    
  end
  
end
