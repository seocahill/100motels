class Ticket < ActiveRecord::Base
  belongs_to :order
  belongs_to :event
  attr_accessible :number, :event_id, :quantity_counter

  before_create :generate_ticket_number
  before_create :calculate_cumulative_quantity_by_email
  after_commit :mail_ticket, on: :create

  scope :event_tickets, proc { |event| joins(:event).where("event_id = ?", event.id) }


  def calculate_cumulative_quantity_by_email
    orders = Order.where(email: self.order.email, event_id: self.event_id).pluck(:id)
    previous_tickets = Ticket.where(order_id: orders).count
    self.quantity_counter = previous_tickets + 1
  end

private

  def generate_ticket_number
    event = Event.find(self.event_id)
    begin
      self.number = rand((9.to_s * 6).to_i).to_s.center(6, rand(9).to_s)
    end while event.tickets.exists?(number: number)
  end

  def mail_ticket
    Notifier.ticket(order_id, self.id).deliver
  end
end
