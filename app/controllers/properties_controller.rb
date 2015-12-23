class PropertiesController < ApplicationController
  before_action :authenticate_user

  def index 
    show_properties
  end
  
  # Show logged in user's selected properties
  def favorites
    
  end
  
  #Receives a user request to bookmark a property
  def bookmark
    property = Property.find(params[:property].to_i)
    return unless property.valid?
    marked = unmarked = false
    #if bookmark already exists, destroy it else create it
    bookmark = Bookmark.find_by(user_id: @current_user.id,property_id: property.id)
    if bookmark.nil?
      Bookmark.create!(user_id: @current_user.id,property_id: property.id)
      marked = true
    else
      bookmark.destroy
      unmarked = true      
    end
    render json: {status: 'ok',marked: marked, unmarked: unmarked}
  end
  
  #Receives a user request to rate product
  def rating
    
  end
  
  # Handle search queries here
  def search
    per_page = 20
    query = params[:query].to_s
    req_page = params[:pg].to_i    
    @order = property_order(params[:orderby].to_i)
    current_page = (req_page >= 1) ? (req_page - 1) : 0    
    offset =  per_page * current_page
    search_query = 'address LIKE :query OR city LIKE :query OR state LIKE :query OR zip like :query'
    search_filter = {query: "%#{query}%"}
    @search_info = {}
    @search_info[:count] = Property.where(search_query,search_filter).count
    @search_info[:query] = query
    pages = (@search_info[:count].to_f/per_page).ceil
    calculate_pagination(current_page+1,pages)
    @properties = Property.where(search_query,search_filter).order(@order[:name] => @order[:order]).limit(per_page).offset(offset)    
  end
  
  private
  def show_properties
    per_page = 20
    req_page = params[:pg].to_i
    @order = property_order(params[:orderby].to_i)    
    current_page = (req_page >= 1) ? (req_page - 1) : 0
    offset =  per_page * current_page
    pages = (Property.count.to_f/per_page).ceil
    calculate_pagination(current_page+1,pages)
    @properties = Property.order(@order[:name] => @order[:order]).limit(per_page).offset(offset)
  end
  
  def calculate_pagination(current_page,pages)
     first_page = 1     
     next_count = prev_count = 4 #how many links to display on page  
     next_page = current_page == pages ? pages : current_page+1     
     prev_page = current_page == first_page ? first_page : current_page-1     
     @pagination = {}
     @pagination[:current_page] = current_page     
     @pagination[:prev_page] = prev_page
     @pagination[:next_page] = pages > 0 ? next_page : current_page
     @pagination[:last_page] = pages > 0 ? pages: current_page
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
  
  def property_order(val)
     arr = [{id: 0,name: :id,order: :desc},
            {id: 1,name: :state,order: :desc},
            {id: 2,name: :city,order: :desc},
            {id: 3,name: :current_price,order: :asc},
            {id: 4,name: :end_date,order: :asc}
            ]
    arr[val]
  end
  
end
