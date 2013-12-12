class Event < ActiveRecord::Base
  enum_accessor :state, [ :guest, :in_progress, :finished]
  validates :name, length: {maximum: 50}
  validates :name, :date, presence: :true
  validates_numericality_of :ticket_price, :allow_nil => true,
      :greater_than_or_equal_to => 5.0,
      :less_than_or_equal_to => 50.0,
      :message => "leave blank for free events or between 5 and 50 dollars for paid events."
  validate :forbid_visible, on: :update
  validate :forbid_date_change, on: :update
  validate :forbid_location_change, on: :update
  belongs_to :user
  has_many :orders
  has_many :tickets, through: :orders

  before_save :convert_to_datetime

  include PgSearch
  pg_search_scope :search,
    against: [:name, :location, :about],
    using: {tsearch: {dictionary: "english"}} #,associated_against: {user: [:state]}

  def self.text_search(query)
    if query.present?
      search(query)
    else
      all
    end
  end

  def forbid_date_change
    if self.orders.present?
      errors.add(:base, "can't change the date of an event with existing orders, send a deferral message instead.") if self.date_changed?
    end
  end

  def forbid_location_change
    if self.orders.present?
      errors.add(:base, "can't change the location of an event with existing orders, create a new event or cancel the orders.") if self.location_changed?
    end
  end

  def forbid_visible
    if self.user.state_unconfirmed?
      errors.add(:base, "sign up to publish events") if self.visible_changed?
    end
  end

  def date_field
    date.strftime("%d/%m/%Y") if date.present?
  end

  def time_field
    date.strftime("%I:%M%p") if date.present?
  end

  def date_field=(date)
    @date_field = Date.parse(date).strftime("%Y-%m-%d")
  end

  def time_field=(time)
    @time_field = Time.parse(time).strftime("%H:%M:%S")
  end

  def convert_to_datetime
    self.date = DateTime.parse("#{@date_field} #{@time_field}")
  end

  auto_html_for :about do
    html_escape
    youtube
    vimeo
    soundcloud
    google_map
    image
    redcarpet(:filter_html => true) #escape_html
    link :target => "_blank", :rel => "nofollow"
  end

  def public?
    self.visible? and !self.user.state_suspended?
  end
end

