class Ticket < ActiveRecord::Base
  belongs_to :order
  belongs_to :event
  attr_accessible :number, :event_id, :quantity_counter

  before_create :generate_ticket_number
  before_create :calculate_cumulative_quantity_by_email
  after_create :mail_ticket

  scope :event_tickets, proc { |event| joins(:event).where("event_id = ?", event.id) }

  def self.text_search(query)
    if query.present?
      search(query)
    else
      scoped
    end
  end

  def calculate_cumulative_quantity_by_email
    orders = Order.where(email: self.order.email, event_id: self.event_id).pluck(:id)
    previous_tickets = Ticket.where(order_id: orders).count
    self.quantity_counter = previous_tickets + 1
  end

private

  def generate_ticket_number
    event = Event.find(self.event_id)
    begin
      self.number = (0...8).map{65.+(rand(26)).chr}.join
    end while event.tickets.exists?(number: number)
  end

  def mail_ticket
    Notifier.delay.ticket(order_id, self.id)
    update_order_state(order)
  end

  def update_order_state(order)
    order.stripe_event = :tickets_sent
    order.save!
  end
end
