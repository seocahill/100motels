class Event < ActiveRecord::Base
  resourcify
  attr_accessible :artist, :date, :doors, :venue, :venue_capacity, :ticket_price, :event_id,
                  :music, :video, :about, :image, :target, :price_modification
  validates :artist, :venue, :date, :ticket_price, presence: true

  has_one  :location, dependent: :destroy
  accepts_nested_attributes_for :location
  has_many :orders
  has_many :requests
  has_many :users, through: :requests

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

  def price_modification
    ticket_price
  end

  def price_modification=(new_price)
    if new_price.ends_with? "%"
      self.ticket_price += (ticket_price * (new_price.to_f / 100)).round(2)
    else
      self.ticket_price = new_price
    end
  end

  def sold_out
    space_left = User.checkedin_count(self.venue)
    "There are #{space_left} tickets left on the door"
  end

  def self.text_search(query)
    if query.present?
      where("artist @@ :q or venue @@ :q", q: "#{query}")
    else
      scoped
    end
  end
end
