class StripeEventsHandler

  def initialize(event)
    @stripe_event = event
  end

  def process_stripe_event
   if @stripe_event.type == 'charge.succeeded'
      print Rails.logger.debug 'webhooks working!'
    end
  end
end