class Event < ActiveRecord::Base
  attr_accessible :artist, :date, :doors, :venue, :capacity, :ticket_price,
                  :music, :video, :about, :image, :target, :location_id, :new_location, :visible, :state
  attr_accessor :new_location
  enum_accessor :state, [ :guest, :member, :rescheduled, :archived, :cancelled, :suspended ]
  validates :artist, :venue, :date, :ticket_price, presence: true
  validate :forbid_date_change, on: :update

  before_save :create_location

  has_many :orders
  has_many :tickets
  has_many :event_users
  has_many :users, through: :event_users
  belongs_to :location

  scope :tonight, lambda { where("date <= ? and date >= ?", Time.now.end_of_day, Time.now) }
  scope :week_end, lambda { where("date <= ? and date >= ?", Time.now.end_of_week, Time.now) }
  scope :month_end, lambda { where("date <= ? and date >= ?", Time.now.end_of_month, Time.now) }
  scope :published, where("state > 0 and state < 3").where(visible: :true)
  scope :active, where("state < 3")

  include PgSearch
  pg_search_scope :search, against: [:artist, :venue],
    using: {tsearch: {dictionary: "english"}},
    associated_against: {location: :address}

  def self.text_search(query)
    if query.present?
      search(query)
    else
      scoped
    end
  end

  def create_location
    self.location = Location.where(address: new_location).first_or_create if new_location.present?
  end

  def forbid_date_change
    if self.orders.present? && self.state_member?
      errors.add(:date, "can't change the date of an active event!") if self.date_changed?
    end
  end

  auto_html_for :video do
    html_escape
    youtube(:width => 630, :height => 430)
    vimeo(:width => 630, :height => 430)
  end

  auto_html_for :music do
    html_escape
    soundcloud(:width => 630, :height => 200)
  end
end

