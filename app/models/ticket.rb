class Ticket < ActiveRecord::Base
  belongs_to :order
  belongs_to :event
  attr_accessible :number, :event_id

  before_create :generate_ticket_number
  after_create :mail_ticket

  scope :event_tickets, proc { |event| joins(:event).where("event_id = ?", event.id) }

  def self.text_search(query)
    if query.present?
      search(query)
    else
      scoped
    end
  end

private

  def generate_ticket_number
    begin
      self.number = (0...8).map{65.+(rand(26)).chr}.join
    end while self.class.exists?(number: number)
  end

  def mail_ticket
    order = self.order
    Notifier.ticket(order, self).deliver
    update_order_state(order)
  end

  def update_order_state(order)
    order.stripe_event = :tickets_sent
    order.save!
  end
end
