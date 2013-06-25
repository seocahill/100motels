class CancelEventOrders

  def initialize(event, params)
    @message = params[:alter_event][:message]
    @event = event
  end

  def cancel_orders
    if @event.orders.present?
      @event.orders.each do |order|
        api_key = User.includes(:event_users).where("event_users.event_id = ? AND event_users.state = 3", event.id).first.api_key
        CancellationsWorker.perform_async(order.id, api_key)
        Notifier.delay.event_cancelled(order.id, message)
        # Notifier.delay_for(30.minutes).event_cancelled(order.id)
      end
      job_status
    end
    @event.state = :cancelled
    @event.save!
  end

  def job_status
    time = Time.now
    order_ids = @event.orders.map(&:id)
    JobStatusWorker.perform_async(order_ids, time)
  end
end