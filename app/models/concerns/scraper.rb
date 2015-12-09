# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Scraper

  module ClassMethods
    
          require 'open-uri'  
          
    def sync
      @@auction = AuctionDotCom.new.fetch_new
#      save_properties_for(@@auction,'auction.com')
      @@home_search = HomeSearchDotCom.new.fetch_new
      binding.pry
    end        
    
    #saves an array of properties for a defined site
    def save_properties_for(properties,site)
      
    end
  
    

  end
  
  #
  #defines set of utility instance methods for all scraper classes
      module Utils 

    #    Returns a specific portion of provided string
    #    from start text to end text
        def str_get_from_to(str,start_txt,end_txt = nil)
          start_from_pos = str.index(start_txt) + start_txt.length
          start_string = str.from(start_from_pos)
          if end_txt
            end_at_pos = start_string.index(end_txt)
            return start_string.to(end_at_pos)
          end      
        end
        
        # extracts a set of defined fields from specified hash
        def get_required_fields(obj, required_fields)
          return_obj = {}          
          required_fields.each { |key, value| return_obj[key] = obj[value] unless value == nil}
          return_obj
        end
        
        #uses a specified value to filter and return reduced version of hash
        def filter_array(arr, field_name, field_values)
          return_arr = []
          arr.each { |value| return_arr.push(value) unless field_values.include?(value[field_name].to_s) }
          return_arr
        end
        
        #removes the dollar sign from a given amount and removes any commas
        def cleanup_price(price)
          price.delete(',$')
        end
        
        #Generates a parse exception record to be saved into the database
        #and to notify admin
        def parse_exception(msg)
          
        end
        
        def log(msg)
          puts msg
        end
        
      end
      

end
