class StripeEventsController < ApplicationController

  def listen
    data = JSON.parse(request.body.read)
    Stripe.api_key = ENV['STRIPE_API_KEY']
    event = Stripe::Event.retrieve(data["id"])
    if StripeEventsHandler.new(event).process_stripe_event
      render text: '', head: :ok
    else
      render text: '', head: :bad_request
    end
  end
end