# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class AuctionDotCom
    
  include Scraper::Utils

  
  def initialize(online_auctions_only = false)
          @total = nil
          @offset = nil #current offset
          @page = 1 #current extracted page
          @assets = [] #all extracted properties saved here  
          @assets_extracted = [] #all @assets with @required_fields saved here  
          @assets_new = [] # all @assets_extracted that are new
          @online_auctions_only = online_auctions_only
          @required_fields = {
            address: 'property_address',
            state: 'property_state',
            city: 'property_city',
            zip: 'property_zip',
            year_built: nil,
            img_thumbnail: 'thumbnail',
            img_large: 'thumbnail',
            auction: nil, #auction or direct sale
            asset_url: 'pdp_url', #url to asset page on site
            source_asset_id: 'global_property_id',
            listed_date: nil,
            internet_sale: nil,
            start_date: 'auction_start_date',
            size: 'sqft',
            current_price: 'starting_bid',
          }
          @home_url = 'https://www.auction.com'
  end
  
  def fetch_new(remove_assets = [])
      log "Fetching new assets from #{@home_url}"    
    fetch_all
    extract_fields
    @assets_new = filter_array(@assets_extracted,:source_asset_id,remove_assets)
  end
  
  def update_property(property)
    log "updating property #{property.id} - auction.com"
    begin
      file = open(property.asset_url,redirect: false) #do not allow redirects
      doc = Nokogiri::HTML(file)
      start_from = 'ADC.model.property = '
      end_at = '};'
      scripts_string = doc.xpath('//script').to_s 
      hash = JSON.parse(str_get_from_to(scripts_string,start_from,end_at)) 
      current_price = hash['bidding']['est_opening_bid']      
      property.start_date = property.end_date = hash['auction_start_date']
      property.current_price =  current_price unless current_price.nil?
      property.save!      
    rescue Exception => e
      if e.class == OpenURI::HTTPRedirect
      #if redirect request has been made, then property no longer exists         
      property.status = false
      property.save!      
      else
        log "property update error - #{e.class} - #{e.message}"        
      end

    end
    
  end
  
  private
    #    
    # Fetches properties available on auction.com las vegas page
    #  Expected object structure
    #  obj = {count=>integer, asset=>array, title=>string, total=>integer, offset=>integer
    #
    #
        def fetch_all
#          
#          EXPECTED FORMAT
#          
#           <script type="text/javascript">
#            var ADC = ADC || {};
#            ADC.model = {};ADC.model.search = {DATA};ADC.model.feature_flags
#            </script>
#            
#          
          url = "#{@home_url}/residential/nv/las-vegas_ct/bm_st/48_rpp/#{@page}_cp/list_vt/y_ag/"
          start_from = 'ADC.model.search = '
          end_at = '};ADC.model.feature_flags'
          doc = Nokogiri::HTML(open(url))
          scripts_string = doc.xpath('//script').to_s
          hash = JSON.parse(str_get_from_to(scripts_string,start_from,end_at))
          #check for parse errors here
          @total = hash['total']
          @offset = hash['offset']
          #check for parse errors
          @assets.push(*hash['asset'])
          if @offset <= @total
            @page += 1               
            fetch_all        
          end
        end
        
        # Gets required fields from extracted assets
        def extract_fields
          @assets.each do |value|     
            online_only =  value['is_asset_online_event']
           if !online_only
              next if @online_auctions_only == true # save only online events
            end
            asset = get_required_fields(value,@required_fields)
            asset[:listed_date] = DateTime.now.strftime('%Y-%m-%d')
            asset[:end_date] = asset[:start_date] #because auction end date has not been specified in json object
                  if value['buying_format'].strip == 'auction'
                  asset[:auction] = true 
                  else
                  asset[:auction] = false 
                  end
                 next if asset[:current_price].nil? #Don't save assets who's price have not been set
             asset[:internet_sale] = online_only.nil? ? true : false
             asset[:img_large] = get_resource_link(asset[:img_large])
             asset[:img_thumbnail] = get_resource_link(asset[:img_thumbnail]) 
             if value['auction_type'] == 'residential'
               asset[:residential] = true
             else
               asset[:residential] = false
             end
             log("Fetched property #{asset[:source_asset_id]} from #{@home_url}")
            #check for field/parse errors here before pushing
            @assets_extracted.push(asset)
          end
        end
  
end
