class PropertiesController < ApplicationController
  before_action :authenticate_user
  helper_method :property

  #Show all active properties
  def index 
    per_page = 20
    req_page = params[:pg].to_i
    @order = property_order(params[:orderby].to_i)    
    current_page = (req_page >= 1) ? (req_page - 1) : 0
    offset =  per_page * current_page
    pages = (Property.where(status: true).count.to_f/per_page).ceil
    calculate_pagination(current_page+1,pages)
    @properties = Property.where(status: true).order(@order[:name] => @order[:order]).limit(per_page).offset(offset)
  end
  
  # Show user's favorite properties
  def favorites
    per_page = 20
    req_page = params[:pg].to_i
    @order = property_order(params[:orderby].to_i)    
    current_page = (req_page >= 1) ? (req_page - 1) : 0
    offset =  per_page * current_page
    pages = (current_user.properties.where(status: true).count.to_f/per_page).ceil
    calculate_pagination(current_page+1,pages)
    @properties = current_user.properties.where(status: true).order(@order[:name] => @order[:order]).limit(per_page).offset(offset)    
  end
  
  
  #Handle search queries here
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
    @search_info[:count] = Property.where(status: true).where(search_query,search_filter).count
    @search_info[:query] = query
    pages = (@search_info[:count].to_f/per_page).ceil
    calculate_pagination(current_page+1,pages)
    @properties = Property.where(status: true).where(search_query,search_filter).order(@order[:name] => @order[:order]).limit(per_page).offset(offset)    
  end

  
#  Saves a note user sends about a specific property
  def notes
        return unless property.valid?
      bookmark = Bookmark.find_by(user_id: current_user.id,property_id: property.id)
      bookmark = Bookmark.create!(user_id: current_user.id,property_id: property.id,rating: 1) if bookmark.nil?
       bookmark.note = params[:note]
       bookmark.note_updated = Time.now
       bookmark.save!
    render json: {saved: true}    
  end
  
  # Displays details of a specific property
  def show
  end
  
  
  #returns the current user rating for a particular property
  def rating
    bookmark = Bookmark.find_by(user_id: current_user.id,property_id: property.id)
    if bookmark.nil?
      rating = 0;
      note = false;
    else
      rating = bookmark.rating  
      note = bookmark.note.present?
    end    
    render json: {property: property.id, rating: rating, note: note}
  end
  
# also creates bookmark
  def set_rating
    bookmark = Bookmark.find_by(user_id: current_user.id,property_id: property.id)
    rating = params[:rating].to_i
    if rating > 0
    bookmark = Bookmark.create!(user_id: current_user.id,property_id: property.id) if bookmark.nil?
    bookmark.rating = rating
    bookmark.save!
    else
      bookmark.destroy if bookmark.present?
    end   
    render json: {property: property.id,rating: rating}
  end
  
  
  private
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
  
  def property
    @property ||= Property.find(params[:id].to_i)
  end
  
end
