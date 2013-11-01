class Ticket < ActiveRecord::Base
  belongs_to :order
  before_create :generate_ticket_number


  def generate_ticket_number
    begin
      self.number = rand((9.to_s * 6).to_i).to_s.center(6, rand(9).to_s)
    end while Ticket.where(order_id: self.order_id).exists?(number: number)
  end
end
