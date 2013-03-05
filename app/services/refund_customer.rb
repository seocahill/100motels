class RefundCustomer

  def initialize(orders)
    @orders = orders
    event = @orders.first.event
    @api_key = User.includes(:event_users).where("event_users.event_id = ? AND event_users.state = 3", event.id).first.api_key
  end

  def refund_charge
    @orders.each { |order| RefundsWorker.perform_async(order.id, @api_key) if [:paid, :tickets_sent].include? order.stripe_event }
  end
end