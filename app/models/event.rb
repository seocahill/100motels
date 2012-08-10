class Event < ActiveRecord::Base
  attr_accessible :artist, :date, :doors, :venue
  validates :artist, :venue, :presence => true
end
