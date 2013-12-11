class CancelService

  def initialize(event, message)
    @message = message.message
    @event = event
    @api_key = event.user.api_key
  end

  def cancel_orders
    if @event.orders.present?
      @event.orders.not_cancelled.each do |order|
        CancellationsWorker.perform_async(order.id, @api_key)
      end
    end
  end
end