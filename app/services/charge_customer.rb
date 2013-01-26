class ChargeCustomer

  def initialize(orders)
    @orders = orders
  end

  def process_charges
    @orders.each { |order| ChargesWorker.perform_async(order.id) }
  end
end