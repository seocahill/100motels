class Location < ActiveRecord::Base
  attr_accessible :address, :new_location
  after_validation :geocode, :if => :address_changed?
  has_one :event
  has_one :user

  geocoded_by :address do |obj,results|
    if geo = results.first
      obj.latitude = geo.latitude
      obj.longitude = geo.longitude
      obj.city    = geo.city
      obj.zip = geo.postal_code
      obj.country = geo.country
    end
  end
end

