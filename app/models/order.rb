class Order < ActiveRecord::Base
  attr_accessible :email, :name, :quantity, :event_id, :user_id, :last4, :stripe_customer_token
  enum_accessor :stripe_event, [ :pending, :paid, :failed, :refunded, :cancelled, :tickets_sent ]

  has_many :tickets, dependent: :destroy
  belongs_to :event
  belongs_to :user

  validates :email, presence: :true
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :quantity, numericality: :true

  scope :sales_today, where("orders.created_at >= ?", Time.now.yesterday)
  scope :pending, where("stripe_event = ?", 0)
  scope :paid, where("stripe_event = ?", 1)
  scope :failed, where("stripe_event = ?", 2)
  scope :refunded, where("stripe_event = ?", 3)
  scope :cancelled, where("stripe_event = ?", 4)
  scope :tickets_sent, where("stripe_event = ?", 5)
end
