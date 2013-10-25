class ChargesController < ApplicationController

  def create
    event = Event.find(params[:event_id])
    # charge orders worker(event)
    redirect_to [:admin, event], notice: "Cool! We're charging your customers, we'll notify you when we're done"
  end

  def receive
    # handle stripe webhooks
  end
end