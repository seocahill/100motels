class Admin::TicketsController < ApplicationController

  def index
    @event = Event.find(params[:event_id])
    @ticket = Ticket.find(params[:ticket]).id unless params[:ticket].blank?
    @tickets = Ticket.includes(:order).where("orders.event_id = ?", @event.id).order("orders.name ASC").page(params[:page]).per_page(15)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = TicketsPdf.new(@event, @tickets, view_context)
        send_data pdf.render, filename: "#{@event.name}_tickets_#{@event.date}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def check
    @ticket = Ticket.find_by(number: params["number"])
    if @ticket
      if @ticket.admitted?
        flash[:warning] = "already admitted at #{@ticket.admitted.strftime('%b %e, %l:%M %p')}"
      else
        @ticket.admitted = Time.now
        @ticket.save!
        flash[:notice] = "Go"
      end
    else
      flash[:notice] = "Ticket not found"
    end
    redirect_to admin_event_tickets_path(ticket: @ticket || "")
  end
end