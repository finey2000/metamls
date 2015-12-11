class Source < ActiveRecord::Base
      include Scraper::InstanceMethods
#  SCHEMA DESCRIPTION
#
# slug              - string                Short name to describe the source
# url               - string                Source web address
# source_type              - string                api, rss_feed or html
# listing_type      - string                auction, buy_now or both
# active            - integer               1 or 0
# update_frequency  - integer               24 hours default
# note              - text                  Special note to tag this source with
# scraper_class     - string                Name of scraper class to handle scraping
#

  validates :slug, presence: true
  validates :url,  presence: true
  validates :source_type, presence: true
  validates :listing_type, presence: true
  validates :scraper_class, presence: true
  
  has_many :properties
  
  class << self
    
    def sync!
#      get all active sources and update their assets database
      sources = ['auction_com','home_search']      
      sources.each { |value| self.find_by(slug: value).sync!}          
    end

  end
  
end
