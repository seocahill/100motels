class Event < ActiveRecord::Base
  attr_accessible :artist, :date, :doors, :venue
end
