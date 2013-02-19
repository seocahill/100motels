class CancellationsWorker
  include Sidekiq::Worker

  def perform(order_id, key)
    order = Order.find(order_id)
    key = key
    cancel_order(order, key)
  end

  def cancel_order(order, key)
    refund_order(order,key) if [:paid, :tickets_sent].include? order.stripe_event
    unless order.stripe_event_cancelled?
      Notifier.order_cancelled(order.id).deliver
      order.stripe_event = :cancelled
      order.save!
    end
  end

  def refund_order(order, key)
    Stripe.api_key = key
    charge = Stripe::Charge.retrieve(order.stripe_charge_id)
    refund = charge.refund
    order.stripe_event = :refunded if refund[:refunded] == true
    Notifier.refund_customer_order(order.id).deliver
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error "Stripe error while processing refund: #{e.message}"
  end
end