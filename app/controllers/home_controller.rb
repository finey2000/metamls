class HomeController < ApplicationController
  before_action :authenticate_user
  
  def index 
#    Get the last 20 properties
    @properties = Property.last(20)
  end
  
end
