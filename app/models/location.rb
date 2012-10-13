class Location < ActiveRecord::Base
  attr_accessible :address, :latitude, :longitude, :event_id
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  belongs_to :event
end

