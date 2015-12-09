class Property < ActiveRecord::Base
  
  
  class << self
    include Scraper::ClassMethods
  end
  
end
