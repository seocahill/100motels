class StripeEventsHandler

  def initialize(event)
    @stripe_event = event
  end

  def process_stripe_event
    case @stripe_event.type
    when 'customer.created' then customer_created
    when 'charge.succeeded' then charge_succeeded
    when 'charge.failed' then charge_failed
    when 'charge.refunded' then charge_refunded
    else false
    end
  end


  def charge_succeeded
    print Rails.logger.debug 'webhooks working!'
  end

  def charge_failed
    # do something
  end
end