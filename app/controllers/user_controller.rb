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
      user =  valid_user?(params[:username], params[:password])
#      save user info into session
      login_user(user)
      redirect_to controller: :home, action: :index        
      rescue Exception => e
        flash.now[:notice] = e.message
      end                  
    end
# else display login form    
  end
  
  def logout
    logout_user
    redirect_to action: :login 
  end
  
  def new
    
  end
  
  
  
end
