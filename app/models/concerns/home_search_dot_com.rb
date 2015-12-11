# manages properties scraped from http://homesearch.com

class HomeSearchDotCom
  include Scraper::Utils  
  def initialize(online_auctions_only = false)
          @home_url = 'https://homesearch.com'
          @page = 1 #current extracted page
          @assets = [] #all extracted properties saved here  
          @assets_new = [] # all @assets_extracted that are new
          @online_auctions_only = online_auctions_only  
          @base_url = "#{@home_url}/Browse?fulltextquery=las%20vegas&viewtype=photo"
          @doc = nil
          @page_count = nil
  end
  
  def fetch_new(remove_assets=[])
    log "Fetching assets from #{@home_url}"
    get_page_count
    fetch_all
    @assets_new = filter_array(@assets,:source_asset_id,remove_assets)    
  end
  
  private
  
  # Returns total number of pages in query site
  def get_page_count
                                         
#         EXPECTED FORMAT
#         
#   <div class="search-utility search-pagination-bottom">
#<ul class="search-pagination">
#   <li><a href="#" class="pagination-active">1 </a></li>
#   <li><a href="/Browse?fulltextquery=las%20vegas&amp;viewtype=photo&amp;page=1">2</a></li>
#   <li><a href="/Browse?fulltextquery=las%20vegas&amp;viewtype=photo&amp;page=2">3</a></li>
#   <li>...</li>
#   <li><a href="/Browse?fulltextquery=las%20vegas&amp;viewtype=photo&amp;page=14">15</a></li>
#   <li><a class="pagination-next" id="pagination-next" href="/Browse?fulltextquery=las%20vegas&amp;viewtype=photo&amp;page=1">Next</a></li>
#</ul></div>
#
#
        doc = Nokogiri::HTML(open("#{@base_url}&page=1"))
        pages = doc.css('.search-pagination-bottom ul li')
        pages.pop # remove the last next link
        @page_count = pages.last.text.strip.to_i - 1 #get the last number and reduce by one
  end
  
  def fetch_all
    doc = Nokogiri::HTML(open("#{@base_url}&page=#{@page}"))
    views = doc.css('div .tile-view-container')
    views.each {|node| extract_values_from_node(node)}
    @page += 1
    fetch_all if @page <= @page_count #get more pages
#extract_values_from_node(views[2])
#binding.pry?
  end
  
   
  
  #gets needed values from nokogiri node
  def extract_values_from_node(node)
    asset = {}
#    
#    
#    EXPECTED PRICE FORMAT
# <span class="bid-amt">$190,000 </span>
#    
    asset[:current_price] = cleanup_price(node.css('.bid-amt').text.strip)
    # => return if current price is not set - Thats a coming soon listing
    return if asset[:current_price].empty?
#    
#    EXPECTED FORMAT TO GRAB asset_id, asset_url and asset image
#    
#  <a class="address-link pdpLink" data-id="5112489" href="/realestate-auction/8624-fire-mountain-circle-las-vegas-nv-89129">
#  <img width="305px" height="229px" src="https://img.homesearch.com/img/20151104/d19c3e66-83ac-41b3-a53f-69100ac3dd67_305x229.jpg" />
#   </a>
    
    asset[:source_asset_id] = node.css('.address-link').attribute('data-id').value
    log "Extracting property #{asset[:source_asset_id]} from #{@home_url}"
    asset[:asset_url] = @home_url + node.css('.address-link').attribute('href').value
    asset[:img_thumbnail] = asset[:img_large] = node.css('a img').attribute('src').value
    address = []
#
#                EXPECTED ADDRESS FORMAT
#
#                <div class="col-xs-12 no-padding result-location">
#                6625 SCAVENGER HUNT STREET, <br />
#                NORTH LAS VEGAS, NV 89084 <br />
#                County: CLARK
#                 </div>

    node.css('.result-location').text.strip.each_line { |line| address.push(line.strip)}
    asset[:address] = address[0].chop
    address2 = address[1].split(',')
    asset[:city] = address2[0]
    address3 = address2[1].strip.split(' ')
    asset[:state] = address3[0]
    asset[:zip] = address3[1]
    
    # Get sale type
    
#    
#    EXPECTED FORMAT TO GET SALE TYPE
# <span id="time-left-data" class="time">
# <span id="time" listing-id="5117636"
# listing-remainingdate="135602910.7019"
# listing-currentdate="12/9/2015 2:59:57 AM"
# listing-status="Active" class="time-search-result"></span>
# </span>
#
#   OR
#
#<span id="time-left-data" class="time-left-data-foreclosure">
# Live Event </span>
#

    sale_type = node.css('#time-left-data').text.strip
    if sale_type == 'Live Event'
      asset[:internet_sale] = false
  else
    asset[:internet_sale] = true
  end
  
    # save only online sales if so specified
          if asset[:internet_sale] == false
              return if @online_auctions_only == true 
            end

    
#    
#             EXPECTED DATE FORMAT
# <div class="tile-auction-time result-time">Auction Starts
# <span class="local_datetime2 datetime">12/5/2015</span></div>
#    
##  <div class="tile-auction-time result-time">Event Date
#   <span class="local_datetime2 datetime">12/15/2015
#   </span></div>
#    
#    
#      

    
    date_selector = '.tile-auction-time.result-time .local_datetime2.datetime'
    
    if asset[:internet_sale]  == false 
    date = node.css(date_selector)[0].text.strip.split('/')
    asset[:start_date] = asset[:end_date] = "#{date[2]}-#{date[0]}-#{date[1]}" #let date be in a parsable format (year-month-day)          
    else
    date1 = node.css(date_selector)[0].text.strip.split('/')
    asset[:start_date] = "#{date1[2]}-#{date1[0]}-#{date1[1]}"  
    date2 = node.css(date_selector)[1].text.strip.split('/')
    asset[:end_date] = "#{date2[2]}-#{date2[0]}-#{date2[1]}"    
    end

    asset[:auction] = true
    asset[:listed_date] = DateTime.now.strftime('%Y-%m-%d')    
   @assets.push(asset)
  end
  
end
