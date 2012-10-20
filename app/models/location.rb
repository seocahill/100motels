class Location < ActiveRecord::Base
  attr_accessible :address, :latitude, :longitude, :event_id, :user_id
  geocoded_by :address
  after_validation :geocode, :if => :address_changed?

  belongs_to :event
  belongs_to :user
end

