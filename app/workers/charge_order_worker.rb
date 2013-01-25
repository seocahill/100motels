class ChargeOrderWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find(order_id)
    organizer = User.find(order.event.users.first)
    print Rails.logger.debug "#{order.id}, #{organizer.id}"
  end
end