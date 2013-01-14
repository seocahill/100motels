class Event < ActiveRecord::Base
  attr_accessible :artist, :date, :doors, :venue, :venue_capacity, :ticket_price,
                  :music, :video, :about, :image, :target, :location_id, :new_location, :visible, :state
  attr_accessor :new_location
  enum_accessor :state, [ :hidden, :visible, :rescheduled, :archived, :cancelled ]
  validates :artist, :venue, :date, :ticket_price, presence: true

  include EmbedMedia

  before_save :create_location

  belongs_to  :location
  has_many :orders

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

  def self.text_search(query)
    if query.present?
      search(query)
    else
      scoped
    end
  end

end
