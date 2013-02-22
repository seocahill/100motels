class CancelEventOrders

  def initialize(orders)
    @orders = orders
    @api_key = User.find(@orders.first.event.users.first).api_key
  end

  def cancel_orders
    time = Time.now
    order_ids = @orders.map(&:id)
    @orders.each { |order| CancellationsWorker.perform_async(order.id, @api_key) }
    JobStatusWorker.perform_async(order_ids, time)
  end
end