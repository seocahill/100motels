class Event < ActiveRecord::Base
  enum_accessor :state, [ :guest, :in_progress, :finished]
  validates :name, length: {maximum: 50}
  validates :name, :date, presence: :true
  validates_numericality_of :ticket_price, :allow_nil => true,
      :greater_than_or_equal_to => 5.0,
      :less_than_or_equal_to => 50.0,
      :message => "leave blank for free events or between 5 and 30 dollars for paid events."
  has_many :orders
  has_one :event_user, dependent: :destroy
  has_one :user, through: :event_user

  include PgSearch
  pg_search_scope :search,
    against: [:name, :location, :about],
    using: {tsearch: {dictionary: "english"}}

  def self.text_search(query)
    if query.present?
      search(query)
    else
      scoped
    end
  end

  def forbid_date_change
    if self.orders.present?
      errors.add(:base, "can't change the date of an active event!") if self.date_changed?
    end
  end

  def forbid_visible
    if self.user.guest?
      errors.add(:base "sign up to publish events") if self.forbid_visible_changed?
    end
  end

  auto_html_for :about do
    html_escape
    redcarpet(:filter_html => true)
    image
    youtube(:width => 400, :height => 250)
    vimeo(:width => 400, :height => 250)
    soundcloud(:maxwidth => 400, :maxheight => 250)
    google_map(:width => 400, :height => 250)
    link :target => "_blank", :rel => "nofollow"
  end

  def defer_event(params)
    self.date = params[:alter_event][:date]
    self.orders.each { |order| OrderMailer.event_deferred(order, params).deliver}
    save!
  end
end

