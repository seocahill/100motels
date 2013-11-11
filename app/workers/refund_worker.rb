class RefundWorker
  include Sidekiq::Worker

  def perform(stripe_event_id)
    process_stripe_event(stripe_event_id)
  end

  def process_stripe_event(stripe_event_id)
    Stripe.api_key = user.api_key
    event = Stripe::Event.retrieve(stripe_event_id)
    if event.present?
      refund_order(event)
    end
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error "Invalid webhook Event request"
  end

  def refund_order(event)
    order = Order.find(event.data.object.description)
    if order and event.data.object.refunded == true
      order.stripe_event = :cancelled
      order.save!
    else
      raise "invalid uuid from stripe event"
    end
  end
end