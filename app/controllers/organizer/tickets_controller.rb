class Organizer::TicketsController < Organizer::BaseController

  def index
    @tickets = Ticket.includes(:order).where("order.stripe_event = 5")
  end
end
