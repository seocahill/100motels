class HooksController < ApplicationController
  require 'json'

  Stripe.api_key = ENV['STRIPE_API_KEY']

  def receiver
    data_json = JSON.parse request.body.read

    if data_json[:type] == "charge.succeeded"
      mark_active(data_event)
    end

    if data_json[:type] == "customer.created"
      # make_inactive(data_event)
    end
  end
end
