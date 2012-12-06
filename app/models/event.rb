class Event < ActiveRecord::Base
  resourcify
  attr_accessible :artist, :date, :doors, :venue, :venue_capacity, :ticket_price,
                  :music, :video, :about, :image, :target, :ticket_discount, :location_id, :new_location, :visible, :state
  attr_accessor :new_location
  enum_accessor :state, [ :hidden, :visible, :successful, :failed, :archived, :cancelled ]
  validates :artist, :venue, :date, :ticket_price, presence: true
  before_save :create_location

  belongs_to  :location
  belongs_to  :profile
  has_many :orders
  has_many :requests
  has_many :users, through: :requests

  scope :tonight, lambda { where("date <= ?", Time.now.end_of_day) }
  scope :week_end, lambda { where("date <= ?", Time.now.end_of_week) }
  scope :month_end, lambda { where("date <= ?", Time.now.end_of_month) }
  scope :event_city, proc { |city| joins(:location).where("city = ?", city) }
  scope :visible, where("state > 0 and state < 3")

  def visible
    state
  end

  def visible=(new_state)
    if new_state == "visible"
      self.state = :visible
    else
      self.state = :hidden
    end
  end

  def create_location
    self.location = Location.create(address: new_location) if new_location.present?
  end

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

  # def ticket_discount
  #   ticket_price if ticket_price
  # end

  # def ticket_discount=(new_price)
  #   if new_price.ends_with? "%"
  #     self.ticket_price += (ticket_price * (new_price.to_f / 100)).round(2)
  #   else
  #     self.ticket_price = new_price
  #   end
  # end

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
