class StripeEventsHandler

  def initialize(event)
    @stripe_event = event
  end

  def process_stripe_event
    case @stripe_event.type
    when 'charge.succeeded' then charge_succeeded
    when 'charge.failed' then charge_failed
    else false
    end
  end


  def charge_succeeded
    print Rails.logger.debug 'webhooks working!'
  end
end