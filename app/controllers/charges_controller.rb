class ChargesController < ApplicationController

  def create
    event = Event.find(params[:event_id])
    ChargeCustomer.new(event).process
    redirect_to [:admin, event], notice: "Cool! We're charging your customers, we'll notify you when we're done"
  end

  def receive
    # Stripe.api_key = ENV['STRIPE_API_KEY']
    # data = JSON.parse(request.body.read)
    # stripe_event_id = data["id"]
    # if request
    #   render text: '', head: :ok
    # else
    #   render text: '', head: :bad_request
    # end
    render text: '', head: :ok
  end
end