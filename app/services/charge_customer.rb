class ChargeCustomer

  def initialize(orders)
    @orders = orders
  end

  def process_charges
    event = @orders.first.event
    capacity = event.capacity
    sales = event.orders.sum(:quantity)
    @orders.each_with_index do |order, index|
      sales += index
      ChargesWorker.perform_async(order.id) if sales <= capacity
    end
  end
end