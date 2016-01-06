# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

module Scraper

  module InstanceMethods
    
          require 'open-uri'  
          
    def sync!
      log "Syncing for #{self.slug}...."
#      Get scraper class and initialize scraper object
      scraper = Object.const_get(self.scraper_class).new
      log "Scraper class is #{scraper.class}..."
#      get an array of old_asset_ids so filtering can be done
      old_asset_ids = Property.where(source_id: self.id).pluck('source_asset_id')
      log "#{old_asset_ids.count} existing assets..."
#      fetch all assets and return new_assets - old_assets
      new_assets = scraper.fetch_new(old_asset_ids)
      log "#{new_assets.count} assets extracted..."  
#      add new assets to properties and source_id = self.id
      self.properties.create!(new_assets)
      log "#{new_assets.count} assets created"  
      update_properties!(scraper)      
    end        
  
    #Updates old existing properties
    def update_properties!(scraper)
      log "Updating assets for #{self.slug}"
#      only update active properties
      Property.where(source_id: self.id, status: 1).find_each do |prop|
        begin
          scraper.update_property(prop)
        rescue Exception => e
          log "there was a connection error #{e.message} - #{e.class}"
        end
      end
    end
  
    def log(msg)
      puts msg
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
          if end_txt.present?
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
        
        #Returns the full url of a given resource        
        def get_resource_link(resource)
          res = resource.to_s
          if res[0] == '/'
            @home_url + res
          else
            res
          end
        end
        
      end
      

end
