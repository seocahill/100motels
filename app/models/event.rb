class Event < ActiveRecord::Base
  resourcify
  attr_accessible :artist, :date, :doors, :venue, :venue_capacity, :ticket_price, :event_id,
                  :music, :video, :about, :image, :target, :location_attributes
  validates :artist, :venue, :date, :ticket_price, presence: true

  has_one  :location, dependent: :destroy
  accepts_nested_attributes_for :location
  has_many :orders
  has_and_belongs_to_many :users

  auto_html_for :video do
    html_escape
    youtube(:width => 630, :height => 430)
    vimeo(:width => 630, :height => 430)
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end

  auto_html_for :music do
    html_escape
    soundcloud(:width => 630, :height => 200)
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end

  def sold_out
    space_left = User.checkedin_count(self.venue)
    "There are #{space_left} tickets left on the door"
  end

end
