class Event < ActiveRecord::Base
  # attr_accessible :date, :ticket_price, :title, :about, :image, :visible, :state
  validates :title, length: {maximum: 50}
  validates :title, :date, :capacity, presence: :true
  validates_numericality_of :ticket_price, :allow_nil => true,
      :greater_than_or_equal_to => 5.0,
      :less_than_or_equal_to => 30.0,
      :message => "leave blank for free events or between 5 and 30 dollars for paid events."

  has_many :orders
  has_many :event_users
  has_one :user, through: :event_users

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

  def forbid_date_change
    if self.orders.present? && self.state_member?
      errors.add(:base, "can't change the date of an active event!") if self.date_changed?
    end
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

