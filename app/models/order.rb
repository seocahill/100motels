class Order < ActiveRecord::Base
  enum_accessor :stripe_event, [:pending, :failed, :charged, :cancelled]

  belongs_to :event
  has_many :tickets, dependent: :destroy

  validates :email, presence: :true
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :quantity, numericality: :true

  after_create :add_tickets_to_order

  scope :pending, -> { where('stripe_event < 1') }
  scope :not_cancelled, -> { where('stripe_event < 3') }

  include PgSearch
  pg_search_scope :search, against: [:name, :email, :id],
  using: {tsearch: {dictionary: "english"}},
  associated_against: {event: [:name, :location], tickets: :number }

  def self.text_search(query)
    if query.present?
      search(query)
    else
      all
    end
  end

  def add_tickets_to_order
    quantity.times { self.tickets.create }
  end
end

