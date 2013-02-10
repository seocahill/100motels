class RefundsWorker
  include Sidekiq::Worker

  def perform(order_id, key)
    order = Order.find(order_id)
    key = key
    refund_order(order, key)
  end

  def refund_order(order, key)
    Stripe.api_key = key
    charge = Stripe::Charge.retrieve(order.stripe_charge_id)
    refund = charge.refund
    order.stripe_event = :refunded if refund[:refunded] == true
    order.save!
    Notifier.refund_customer_order(order.id).deliver
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error "Stripe error while processing refund: #{e.message}"
  end
end