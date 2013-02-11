class Order < ActiveRecord::Base
  attr_accessible :email, :name, :quantity, :event_id, :user_id, :last4, :stripe_customer_token
  enum_accessor :stripe_event, [ :pending, :paid, :tickets_sent, :failed, :refunded, :cancelled, ]

  has_many :tickets, dependent: :destroy
  belongs_to :event
  belongs_to :user

  validates :email, presence: :true
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :quantity, numericality: :true

  scope :funding, where("stripe_event < ?", 3)
  scope :pending, where("stripe_event = ?", 0)
  scope :paid, where("stripe_event = ?", 1)
  scope :tickets_sent, where("stripe_event = ?", 2)
  scope :failed, where("stripe_event = ?", 3)
  scope :refunded, where("stripe_event = ?", 4)
  scope :cancelled, where("stripe_event = ?", 5)

  include PgSearch
  pg_search_scope :search, against: [:name, :email],
    using: {tsearch: {dictionary: "english"}},
    associated_against: {event: [:artist, :venue], tickets: :number }

  def self.text_search(query)
    if query.present?
      search(query)
    else
      scoped
    end
  end
end
