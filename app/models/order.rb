class Order < ActiveRecord::Base
  enum_accessor :stripe_event, [:pending, :failed, :charged, :cancelled]

  belongs_to :event

  validates :email, presence: :true
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :quantity, numericality: :true

  before_create :generate_uuid
  # before_create :generate_tickets

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

  def generate_uuid
    begin
      self.uuid = SecureRandom.hex
    end while self.class.exists?(uuid: uuid)
  end

  def generate_unique_ticket
    begin
      return rand((9.to_s * 6).to_i).to_s.center(6, rand(9).to_s)
    end while self.event.orders.where("'#{@new_ticket}' = ANY (tickets)").present?
  end

   def add_tickets_to_order
    self.quantity.times do
      self.tickets << self.generate_unique_ticket
    end
    self.tickets_will_change!
    save!
  end
end

