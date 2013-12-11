class CancellationsWorker
  include Sidekiq::Worker

  def perform(order_id, key)
    order = Order.find(order_id)
    key = key
    cancel_order(order, key)
  end

  def cancel_order(order, key)
    if order.stripe_event_charged?
      refund_order(order, key)
    else
      order.stripe_event = :cancelled
      order.save!
    end
    order
  end

  def refund_order(order, key)
    Stripe.api_key = key
    charge = Stripe::Charge.retrieve(order.stripe_charge_id)
    refund = charge.refund
    order.stripe_event = :cancelled if refund[:refunded] == true
    order.save!
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error "Stripe error while processing refund: #{e.message}"
  end
end