class ChargesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :receive
  require 'json'

  def create
    event = Event.find(params[:event_id])
    ChargeCustomer.new(event).process
    redirect_to [:admin, event], notice: "Cool! We're charging your customers, we'll notify you when we're done"
  end

  def receive
    Stripe.api_key = ENV['STRIPE_API_KEY']
    raw_body = request.body.read
    json = JSON.parse raw_body
    if json
      render text: '', head: :ok
    else
      render text: '', head: :bad_request
    end
  end
end