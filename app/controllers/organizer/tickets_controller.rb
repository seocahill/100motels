class Organizer::TicketsController < Organizer::BaseController

  def index
    @events = current_user.events
    @event = Event.find(params[:event_id])
    @tickets = @event.tickets.order('quantity_counter, updated_at').joins(:order).where("stripe_event = 2 OR stripe_event = 4")
    respond_to do |format|
      format.html { redirect_to :back }
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
