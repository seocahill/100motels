class Event < ActiveRecord::Base
  attr_accessible :artist, :date, :doors, :venue, :capacity, :ticket_price, :title,
                  :music, :video, :about, :image, :target, :location_id, :new_location,
                  :visible, :state, :first_support, :second_support, :third_support
  attr_accessor :new_location
  enum_accessor :state, [ :guest, :member, :rescheduled, :archived, :cancelled, :suspended ]
  validates :artist, :first_support, :second_support, :third_support, length: {maximum: 30}
  validates :title, length: {maximum: 50}
  validates :capacity, numericality: { less_than_or_equal_to: 200 , message: "Max capacity is 200 during beta" }
  validates :target, numericality: { less_than_or_equal_to: :capacity }
  validates :title, :artist, :venue, :date, :capacity, :doors, :target, presence: :true
  validates_numericality_of :ticket_price, :allow_nil => true,
      :greater_than_or_equal_to => 5.0,
      :less_than_or_equal_to => 30.0,
      :message => "leave blank for free events or between 5 and 30 dollars for paid events."

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
  pg_search_scope :search, against: [:venue, :about, :title, :artist],
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
      errors.add(:base, "can't change the date of an active event!") if self.date_changed?
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

  auto_html_for :about do
    html_escape
    link target: "_blank", rel: "nofollow"
    simple_format
  end

  def defer_event(params)
    self.date = params[:alter_event][:date]
    self.orders.each { |order| OrderMailer.event_deferred(order, params).deliver}
    save!
  end

  def duplicate(current_user, request)
    location = request.location.present? ? request.location.address : self.location.address
    copy = self.dup
    copy.title = "Copy of #{self.title}"
    copy.state = current_user.guest? ? :guest : :member
    copy.event_users.build(user_id: current_user.id, state: :event_admin)
    copy.build_location(address: location)
    copy.save!
  end
end

