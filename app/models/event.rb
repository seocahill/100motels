class Event < ActiveRecord::Base
  attr_accessible :artist, :date, :doors, :venue, :ticket_price
  validates :artist, :venue, :date, :ticket_price, :presence => true
end
