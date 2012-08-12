class Event < ActiveRecord::Base
  attr_accessible :artist, :date, :doors, :venue, :ticket_price
  validates :artist, :venue, :date, :ticket_price, :presence => true


  def sold_out
    space_left = User.checkedin_count(self.venue)
    "There are #{space_left} tickets left on the door"
  end

end
