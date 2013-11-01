class Order < ActiveRecord::Base
  enum_accessor :stripe_event, [:pending, :failed, :charged, :cancelled]

  belongs_to :event
  has_many :tickets, dependent: :destroy

  validates :email, presence: :true
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :quantity, numericality: :true

  before_create :add_tickets_to_order

  scope :pending, -> { where('stripe_event < 1') }
  scope :not_cancelled, -> { where('stripe_event < 3') }

  def self.searchable_language
    'english'
  end

  def self.text_search(query)
    if query.present?
      Order.search(query)
    else
      scoped
    end
  end

  def add_tickets_to_order
    quantity.times { self.tickets.build }
  end
end

