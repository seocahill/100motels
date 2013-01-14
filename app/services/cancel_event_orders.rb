class CancelEventOrders

  def initialize(event, order)
    @event = event
    @order = order
    @organizer = User.find(@event.promoter_id)
  end

  def cancel_or_refund_order
    @order.stripe_event == :paid ? refund_order : cancel_order
    Notifier.event_cancelled.deliver(@order)
  end

  def cancel_order
    @order.stripe_event = :cancelled
    @order.save!
  end

  def refund_order
    RefundCustomer.new(@order, @organizer).refund_charge
  end
end