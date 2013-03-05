class CancelEventOrders

  def initialize(orders)
    @orders = orders
    event = @orders.first.event
    @api_key = User.includes(:event_users).where("event_users.event_id = ? AND event_users.state = 3", event.id).first.api_key
  end

  def cancel_orders
    time = Time.now
    order_ids = @orders.map(&:id)
    @orders.each { |order| CancellationsWorker.perform_async(order.id, @api_key) }
    JobStatusWorker.perform_async(order_ids, time)
  end
end