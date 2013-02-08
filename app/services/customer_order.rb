class CustomerOrder

  def initialize(order, token)
    @order = order
    @token = token
  end

  def process_order
    if @order.valid?
      add_total_to_order
      CustomerOrderWorker.perform_async(@order.id, @token)
    end
  end

  def add_total_to_order
    event = Event.find(@order.event_id)
    @order.total = (@order.quantity * (event.ticket_price / 0.961) + 0.30).round(2)
    @order.save!
  end
end