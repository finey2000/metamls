class UserController < ApplicationController
  
  #user must be logged in to see this page
  def index
    if !logged_in?
      redirect_to action: :login
    end
  end
  
  def login
#    redirect to home if already logged in
    if logged_in?
      redirect_to controller: :home, action: :index 
    end
#    if login request is posted
    if params[:username]      
      begin
      user_id =  User.valid_user?(params[:username], params[:password])
#      save user info into session
      session[:current_user_id] = user_id
      redirect_to controller: :home, action: :index        
      rescue Exception => e
        flash.now[:notice] = e.message
      end                  
    end
# else display login form    
  end
  
  def logout
    session[:current_user_id] = nil
    redirect_to action: :login 
  end
  
  def new
    
  end
  
  private
  #loads user from the session
  def load_user
    
  end
  
  def logged_in?
    session[:current_user_id]
  end
  
end
