class StripeEventsController < ApplicationController
  require 'json'

  def listen
    data = JSON.parse(request.body.read)
    print logger.info "Received event with ID: #{data["id"]} Type: #{data["type"]}"
    render text: '', head: :ok

    Stripe.api_key = ENV['STRIPE_API_KEY']
    event = Stripe::Event.retrieve(data["id"])

    StripeEventsHandler.new(event).process_stripe_event
  end
end