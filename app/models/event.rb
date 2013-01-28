class Event < ActiveRecord::Base
  attr_accessible :artist, :date, :doors, :venue, :capacity, :ticket_price,
                  :music, :video, :about, :image, :target, :location_id, :new_location, :visible, :state
  attr_accessor :new_location
  enum_accessor :state, [ :guest, :member, :rescheduled, :archived, :cancelled ]
  validates :artist, :venue, :date, :ticket_price, presence: true

  before_save :create_location

  has_many :orders
  has_many :tickets
  has_many :event_users
  has_many :users, through: :event_users
  belongs_to :location

  scope :tonight, lambda { where("date <= ? and date >= ?", Time.now.end_of_day, Time.now) }
  scope :week_end, lambda { where("date <= ? and date >= ?", Time.now.end_of_week, Time.now) }
  scope :month_end, lambda { where("date <= ? and date >= ?", Time.now.end_of_month, Time.now) }
  scope :event_city, proc { |city| joins(:location).where("city = ?", city) }
  scope :visible, where("state > 0 and state < 3").where(visible: :true)


  def create_location
    self.location = Location.where(address: new_location).first_or_create if new_location.present?
  end

  def self.text_search(query)
    if query.present?
      search(query)
    else
      scoped
    end
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
end

