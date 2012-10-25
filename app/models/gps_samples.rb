class GpsSamples < ActiveRecord::Base
  attr_accessible :user_id, :latitude, :longitude, :time
end
