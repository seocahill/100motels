class RefundWorker
  include Sidekiq::Worker

  def perform(stripe_event_id, user_id)
    user = User.find_by(stripe_uid: user_id)
    process_stripe_event(stripe_event_id, user.api_key)
  end

  def process_stripe_event(stripe_event_id, api_key)
    Stripe.api_key = api_key
    event = Stripe::Event.retrieve(stripe_event_id)
    refund_order(event) if event.present?
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error "Invalid webhook Event request"
  end

  def refund_order(event)
    order = Order.find(event.data.object.description)
    if order and event.data.object.refunded == true
      order.stripe_event = :cancelled
    elsif order and event.data.object.refunded == false
      order.part_refund = event.data.object.amount_refunded.to_d / 100
    else
      raise "refund could not be processed"
    end
    order.save
    order
  end
end