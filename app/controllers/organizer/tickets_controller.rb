class Organizer::TicketsController < Organizer::BaseController

  def index
    @events = current_user.events
    @event = Event.find(params[:event_id])
    @tickets = @event.tickets.text_search(params[:query]).joins(:order).where("stripe_event = ?", 5).order('name, updated_at')
    respond_to do |format|
      format.html
      format.pdf do
        pdf = TicketPdf.new(@event, @tickets, view_context)
        send_data pdf.render, filename: "#{@event.artist}_#{@event.date}_tickets.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def update
    @ticket = Ticket.find(params[:id])
    @ticket.admitted = Time.now
    @ticket.save!
    redirect_to :back, notice: "#{@ticket.order.name} was admitted"
  end
end
