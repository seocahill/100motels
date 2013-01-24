class CustomerOrderWorker
  include Sidekiq::Worker

  sidekiq_options queue: "high"
  # sidekiq_options retry: false

  def perform(order_id)
    order = Order.find(order_id)
    Notifier.order_processed(order).deliver
  end
end