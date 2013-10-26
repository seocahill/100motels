class ChargesController < ApplicationController

  def create
    event = Event.find(params[:event_id])
    ChargeCustomer.new(event).process
    redirect_to [:admin, event], notice: "Cool! We're charging your customers, we'll notify you when we're done"
  end

  def receive
    # handle stripe webhooks
  end
end