class StripeEventsHandler

  # def initialize(event)
  #   @stripe_event = event
  # end

  # def process_stripe_event
  #   case @stripe_event.type
  #   when 'customer.created' then customer_created
  #   when 'charge.succeeded' then charge_succeeded
  #   when 'charge.failed' then charge_failed
  #   when 'charge.refunded' then charge_refunded
  #   else false
  #   end
  # end


  # def charge_succeeded
  #   # check to make sure the refund was handled correctly by 100 Motels,
  #   # if not reprocess the transaction in the background
  # end

  # def charge_refunded
  #   # check to make sure the refund was handled correctly by 100 Motels,
  #   # if not reprocess the transaction in the background

  # def charge_failed
  #   # check to make sure the refund was handled correctly by 100 Motels,
  #   # if not reprocess the transaction in the background
  # end

end