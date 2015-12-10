class Source < ActiveRecord::Base
  
#  SCHEMA DESCRIPTION
#
# slug              - string                Short name to describe the source
# url               - string                Source web address
# type              - string                api, rss_feed or html
# listing_type      - string                auction, buy_now or both
# active            - integer               1 or 0
# update_frequency  - integer               24 hours default
# note              - text                  Special note to tag this source with
# 
#
  
  has_many :properties
  
end
