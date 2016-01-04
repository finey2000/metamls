class GetPropertiesJob < ActiveJob::Base
  queue_as :default
  RUN_EVERY = 24.hours
  
  after_perform do 
#    run job again in 24hours
      self.class.set(wait_until: RUN_EVERY).perform_later
  end
  
  def perform
    # Get latest properties
          Source.sync!    
  end
  
end
