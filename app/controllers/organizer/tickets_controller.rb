class Organizer::TicketsController < Organizer::BaseController

  def index
    @events = Event.where(promoter_id: current_user.id)
    @event = Event.find(params[:event_id])
    @tickets = @event.tickets.text_search(params[:query])
  end

  def update
    @ticket = Ticket.find(params[:id])
    @ticket.admitted = Time.now
    @ticket.save!
    redirect_to :back, notice: "Sham was admitted"
  end
end
