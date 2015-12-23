class Bookmark < ActiveRecord::Base
  
  # SCHEMA
  # 
  # id                int
  # user_id           
  # property_id
  # alert             boolean           - specify if to send user alerts on this property
  # rating            int               - Save the user's current rating for this property
  # note              text              - User's essay about this property if any
  # note_updated      timestamp         - The date of the last note update
  # created_at
  # updated_at
  #
  
#  validates :property_id, presence: true  
  validates_uniqueness_of :property_id, :scope => :user_id  #make sure that source does not have same asset id again
  
  belongs_to :property,  {inverse_of: :bookmarks, required: true, validate: true}
  belongs_to :user, {inverse_of: :bookmarks, required: true, validate: true}
  
end
