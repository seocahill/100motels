class Order < ActiveRecord::Base
  attr_accessible :email, :name, :quantity, :event_id, :user_id, :last4, :stripe_customer_token
  enum_accessor :stripe_event, [ :pending, :paid, :tickets_sent, :failed, :refunded, :cancelled, ]

  has_many :tickets, dependent: :destroy
  belongs_to :event
  belongs_to :user

  validates :email, presence: :true
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :quantity, numericality: :true

  before_create :generate_uuid
  after_commit :mail_order_notifiers, on: :create

  scope :funding, where("stripe_event < ?", 3)
  scope :pending, where("stripe_event = ?", 0)
  scope :paid, where("stripe_event = ?", 1)
  scope :tickets_sent, where("stripe_event = ?", 2)
  scope :failed, where("stripe_event = ?", 3)
  scope :refunded, where("stripe_event = ?", 4)
  scope :cancelled, where("stripe_event = ?", 5)

  include PgSearch
  pg_search_scope :search, against: [:name, :email, :uuid],
    using: {tsearch: {dictionary: "english"}},
    associated_against: {event: [:artist, :venue], tickets: :number }

  def self.text_search(query)
    if query.present?
      search(query)
    else
      scoped
    end
  end

  def generate_uuid
    begin
      self.uuid = SecureRandom.hex
    end while self.class.exists?(uuid: uuid)
  end

  def mail_order_notifiers
    OrderMailer.delay.order_created(self.id)
    OrderMailer.delay.notify_admin_order_created(self.id)
  end

  def total_price
    event.ticket_price.nil? ? 0.0 : (quantity * event.ticket_price)
  end

  def cancel_order
    if stripe_event_pending?
      self.stripe_event = :cancelled
      OrderMailer.delay.order_cancelled(self.id)
      save!
    end
  end
end
