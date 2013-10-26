class CancellationsWorker
  include Sidekiq::Worker

  def perform(order_id, key)
    order = Order.find(order_id)
    key = key
    cancel_order(order, key)
  end

  def cancel_order(order, key)
    if order.stripe_event_charged?
      if refund_order(order, key)?
        order.stripe_event = :cancelled
        OrderMailer.order_cancelled(order.id).deliver
      end
    else
      order.stripe_event = :cancelled
      OrderMailer.order_cancelled(order.id).deliver
    end
    order.save!
  end

  def refund_order(order, key)
    Stripe.api_key = key
    charge = Stripe::Charge.retrieve(order.stripe_charge_id)
    refund = charge.refund
    refund[:refunded] == true
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error "Stripe error while processing refund: #{e.message}"
    false
  end
end