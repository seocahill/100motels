Stripe.api_key = ENV['STRIPE_API_KEY']

StripeEvent.setup do

  subscribe 'charge.failed' do |event|
    #nothing here
  end

  subscribe 'charge.succeeded' do |event|
    StripeWebhooks.new.charge_succeeded(event)
  end

  subscribe 'customer.created', 'customer.updated' do |event|
    # Handle multiple event types
  end

  subscribe do |event|
    # Handle all event types - logging, etc.
  end
end