class Admin::MessagesController < ApplicationController

  def new
    @event = Event.find(params[:event_id])
  end

  def create
    @event = Event.find(params[:event_id])
    if params[:commit] == "Defer"
      redirect_to [:admin, @event], notice: "Event has been deferred"
    elsif params[:commit] == "Cancel"
      redirect_to [:admin, @event], notice: "Event has been cancelled"
    elsif params[:commit] == "Message"
      redirect_to [:admin, @event], notice: "Message Sent to Customers"
    else
      flash[:error] = "Message couldn't be sent."
      render action: "new"
    end
  end

end
