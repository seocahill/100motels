class RefundCustomer

  def initialize(orders)
    @orders = orders
    @api_key = User.find(@orders.first.event.users.first).api_key
  end

  def refund_charge
    @orders.each { |order| RefundsWorker.perform_async(order.id, @api_key) if [:paid, :tickets_sent].include? order.stripe_event }
  end
end