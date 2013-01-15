class Order < ActiveRecord::Base
  attr_accessible :email, :name, :quantity, :event_id, :user_id
  enum_accessor :stripe_event, [ :pending, :paid, :failed, :refunded, :cancelled, :dummy ]

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
  scope :total, where("stripe_event <= ?", 1)
end
