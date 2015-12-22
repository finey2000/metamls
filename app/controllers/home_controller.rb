class HomeController < ApplicationController
  before_action :authenticate_user
  
  def index
    redirect_to controller: :properties, action: :index
  end
  
end
