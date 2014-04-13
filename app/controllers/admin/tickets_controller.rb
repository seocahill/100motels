class Admin::TicketsController < Admin::BaseController
  before_action do
    authorized?(params[:event_id])
  end

  def index
    @event = Event.find(params[:event_id])
    @ticket = Ticket.find(params[:ticket]).id unless params[:ticket].blank?
    @tickets = @event.tickets.order("number ASC").page(params[:page]).per_page(15)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = TicketsPdf.new(@event, @tickets)
        send_data pdf.render, filename: "#{@event.name}_tickets_#{@event.date}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def check
    event = Event.find(params[:event_id])
    @ticket = event.tickets.find_by(number: params["number"])
    case
    when @ticket.nil?
      flash[:notice] = "Ticket not found"
    when @ticket.admitted
      flash[:warning] = "already admitted at #{@ticket.admitted.strftime('%b %e, %l:%M %p')}"
    when !@ticket.admitted
        @ticket.update_attributes(admitted: Time.now)
        flash[:notice] = "Admit ticket-holder"
    end
    redirect_to admin_event_tickets_path(ticket: @ticket || "")
  end
end