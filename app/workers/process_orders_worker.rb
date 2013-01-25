class CustomerOrderWorker
  include Sidekiq::Worker

  sidekiq_options queue: "high"
  # sidekiq_options retry: false

  def perform(order_id, user_id)
    order = Order.find(order_id)
    user = User.find(user_id)
    ChargeCustomer.new(order, user).process_charge if [:pending, :failed].include? order.stripe_event
    order.quantity.times {order.tickets.create(event_id: order.event_id)} if order.stripe_event == :paid
  end
end