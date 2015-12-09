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
            state: 'venue_state',
            city: 'property_city',
            zip: 'property_zip',
            year_built: nil,
            img_thumbnail: 'thumbnail',
            img_large: 'thumbnail',
            auction: nil, #auction or direct sale
            asset_url: 'pdp_url', #url to asset page on site
            site_asset_id: 'global_property_id',
            listed_date: nil,
            live_sale: nil,
            start_date: 'auction_start_date',
            size: 'sqft',
            current_price: 'starting_bid',
            asset_type: 'auction_type' #residential or business property
          }
          @home_url = 'https://www.auction.com'
  end
  
  def fetch_new(remove_assets = [])
      log "Fetching new assets from #{@home_url}"    
    fetch_all
    extract_fields
    @assets_new = filter_array(@assets_extracted,'site_asset_id',remove_assets)
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
             asset[:live_only] = online_only.nil? ? false : true
             log("Fetched property #{asset[:site_asset_id]} from #{@home_url}")
            #check for field/parse errors here before pushing
            @assets_extracted.push(asset)
          end
        end
  
end