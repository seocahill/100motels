class CancelEventOrders

  def initialize(orders)
    @orders = orders
    @api_key = User.find(@orders.first.event.users.first).api_key
  end

  def cancel_orders
    @orders.each { |order| CancellationsWorker.perform_async(order.id, @api_key) }
  end
end