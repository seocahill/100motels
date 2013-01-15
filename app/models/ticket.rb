class Ticket < ActiveRecord::Base
  belongs_to :order
  belongs_to :event
  attr_accessible :number, :event_id

  before_create :generate_ticket_number
  after_create :mail_ticket

private

  def generate_ticket_number
    begin
      self.number = (0...8).map{65.+(rand(26)).chr}.join
    end while self.class.exists?(number: number)
  end

  def mail_ticket
    order = self.order
    Notifier.ticket(order, ticket).deliver
  end
end
