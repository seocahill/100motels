class Organizer::TicketsController < Organizer::BaseController

  def index
    @events = current_user.events
    @event = Event.find(params[:event_id])
    @tickets = @event.tickets.text_search(params[:query]).joins(:order).order('name, updated_at')
  end

  def update
    @ticket = Ticket.find(params[:id])
    @ticket.admitted = Time.now
    @ticket.save!
    redirect_to :back, notice: "#{@ticket.order.name} was admitted"
  end
end
