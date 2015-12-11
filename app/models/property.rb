class Property < ActiveRecord::Base
  #
  #     PROPERTY/ASSET CLASS
  #
  # SCHEMA DESCRIPTION
  # 
  # asset_url             -  string        url to property on source website
  # source_asset_id       -  string        unique id identifying asset on source website
  # address               -  string
  # city                  -  string
  # state                 -  string
  # zip                   -  integer
  # img_thumbnail         -  string        url to thumbnail image
  # img_large             -  string        url to large image
  # listed_date           -  timestamp
  # start_date            -  timestamp
  # end_date              -  timestamp
  # current_price         -  decimal
  # auction               -  boolean      auction or buy_now
  # internet_sale         -  boolean      internet_sale or live_sale
  # residential           -  boolean       residential or commercial property
  # size                  -  string
  # year_built            -  integer
  #
  
  
  validates :asset_url, presence: true
  validates :source_asset_id, presence: true
  validates :address, presence: true
  validates :city, presence: true  
  validates :state, presence: true  
  validates :zip, length: {minimum: 5}, presence: true  
  validates :start_date, presence: true  
  validates :current_price, presence: true  
  validates_inclusion_of :auction, in: [true, false]    
  validates_inclusion_of :internet_sale, in: [true, false]    
  validates :year_built, length: {minimum: 4}, allow_blank: true
  
  
  belongs_to :source, inverse_of: :properties
  
  class << self

  end
  
end
