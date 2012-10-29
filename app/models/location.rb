class Location < ActiveRecord::Base
  attr_accessible :address, :latitude, :longitude, :location_id, :new_location_address

  geocoded_by :address
  # after_validation :geocode, :if => :address_changed?

  reverse_geocoded_by :latitude, :longitude do |obj,results|
    if geo = results.first
      obj.city    = geo.city
      obj.zip = geo.postal_code
      obj.country = geo.country
    end
  end
  after_validation :geocode, :reverse_geocode

  has_one :events
end

