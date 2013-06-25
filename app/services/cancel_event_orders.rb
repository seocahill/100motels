class CancelEventOrders

  def initialize(orders, params)
    @orders = orders
    @message = params[:alter_event][:message]
    event = @orders.first.event
    @api_key = User.includes(:event_users).where("event_users.event_id = ? AND event_users.state = 3", event.id).first.api_key
  end

  def cancel_orders
    @orders.each do |order|
      CancellationsWorker.perform_async(order.id, @api_key)
      Notifier.delay.event_cancelled(order.id, message)
      # Notifier.delay_for(30.minutes).event_cancelled(order.id)
    end
    job_status
  end

  def job_status
    time = Time.now
    order_ids = @orders.map(&:id)
    JobStatusWorker.perform_async(order_ids, time)
  end
end