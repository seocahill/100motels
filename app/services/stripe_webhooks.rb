class StripeWebhooks

  def charge_succeeded(event)
    logger.error "Stripe error while creating customer: #{event.type}"
  end
end