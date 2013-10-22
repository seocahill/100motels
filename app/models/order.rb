class Order < ActiveRecord::Base
  enum_accessor :stripe_event, [ :pending, :paid, :tickets_sent, :failed, :refunded, :cancelled, ]

  belongs_to :event

  validates :email, presence: :true
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :quantity, numericality: :true

  before_create :generate_uuid
  # before_create :generate_tickets

  # after_commit :mail_order_notifiers, on: :create

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
    price.nil? ? 0.0 : (quantity * price)
  end

  def cancel_order
    if stripe_event_pending?
      self.stripe_event = :cancelled
      OrderMailer.delay.order_cancelled(self.id)
      save!
    end
  end

  def generate_ticket_number
    event = Event.find(self.event_id)
    begin
      self.number = rand((9.to_s * 6).to_i).to_s.center(6, rand(9).to_s)
    end while event.tickets.exists?(number: number)
  end
end
