class Ticket < ActiveRecord::Base

private

  def generate_ticket_number
    event = Event.find(self.event_id)
    begin
      self.number = rand((9.to_s * 6).to_i).to_s.center(6, rand(9).to_s)
    end while event.tickets.exists?(number: number)
  end
end
