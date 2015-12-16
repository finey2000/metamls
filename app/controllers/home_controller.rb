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
    pages = (Property.count/per_page).ceil
    calculate_pagination(current_page+1,pages)
    @properties = Property.order(id: :desc).limit(per_page).offset(offset)
  end
  
  def calculate_pagination(current_page,pages)
     first_page = 1     
     next_count = prev_count = 4 #how many links to display on page  
     next_page = current_page == pages ? pages : current_page+1     
     prev_page = current_page == first_page ? first_page : current_page-1     
     @pagination = {}
     @pagination[:current_page] = current_page     
     @pagination[:prev_page] = prev_page
     @pagination[:next_page] = next_page
     @pagination[:last_page] = pages
     @pagination[:first_page] = first_page
     @pagination[:prev_pages] = []
     @pagination[:next_pages] = []
#    Calculate next page numbers
    if current_page < pages
              while next_page
                @pagination[:next_pages].push(next_page)
                next_page += 1
                next_page = false if next_page > pages
                next_page = false if next_page == (current_page + next_count)                
              end
    end    
#    Calculate previous page numbers
    if current_page > first_page
              while prev_page
                @pagination[:prev_pages].push(prev_page)
                prev_page -= 1
                prev_page = false if prev_page <= 1
                prev_page = false if prev_page == (current_page - prev_count)                
              end
              @pagination[:prev_pages].reverse!
    end    

  end
  
end
