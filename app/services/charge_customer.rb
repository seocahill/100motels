class ChargeCustomer

  def initialize(event)
    @orders = event.orders.where("stripe_event < 2")
    @api_key = event.user.api_key
  end

  def process
    @orders.each do |order|
      ChargesWorker.perform_async(order.id, @api_key)
    end
  end
end