class WebhookHandlerService

  def initialize(event)
    @event = event
  end

  def cancel_orders
    if @event["type"] == "charge.refunded"
      RefundWorker.perform_async(@event["id"], @event["user_id"])
    end
  end
end