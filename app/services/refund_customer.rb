class RefundCustomer

  def initialize(order, organizer)
    @order = order
    @organizer = organizer
  end

  def refund_charge
    Stripe.api_key = @organizer.api_key
    charge = Stripe::Charge.retrieve(@order.stripe_charge_id)
    refund = charge.refund
    @order.stripe_event = :refunded if refund[:refunded] == true
    @order.save!
    Notifier.refund_customer_order(@order).deliver
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error "Stripe error while processing refund: #{e.message}"
  end

  def part_refund_charge
    # in case of discounting ticket price or other similar scenario
  end
end