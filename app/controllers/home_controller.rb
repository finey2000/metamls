class HomeController < ApplicationController
  before_action :authenticate_user
  
  def index 
    show_properties
  end
  
  
  private
  def show_properties
    per_page = 20
    req_page = params[:pg].to_i
    current_page = (req_page >= 1) ? (req_page - 1) : 0
    offset =  per_page * current_page
    calculate_pagination(current_page+1,per_page,Property.count)
    @properties = Property.order(id: :desc).limit(per_page).offset(offset)
  end
  
  def calculate_pagination(current_page,per_page,total)
     pages = (total/per_page).ceil
     next_count = prev_count = 3 #how many links to display on page
     @pagination = {}
     @pagination[:current_page] = current_page     
     @pagination[:prev_page] = (current_page - 1) unless current_page == 1
     @pagination[:next_page] = (current_page + 1) unless current_page == pages     
     @pagination[:last_page] = pages
     @pagination[:first_page] = 1
     @pagination[:prev_pages] = []
     @pagination[:next_pages] = []
     if current_page > prev_count
          for prevc in ((current_page-prev_count)..(current_page-1))
            @pagination[:prev_pages].push(prevc)
          end
     end
     
    if pages > (current_page+next_count)
              for nextc in ((current_page+1)..(current_page+next_count))
                @pagination[:next_pages].push(nextc)
              end
    end

  end
  
end
