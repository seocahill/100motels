class Event < ActiveRecord::Base
  attr_accessible :artist, :date, :doors, :venue
  validates :artist, :presence => true
end
