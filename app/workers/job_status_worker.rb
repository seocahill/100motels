class JobStatusWorker
  include Sidekiq::Worker

  def perform(order_ids, time)
    @orders = Order.find(order_ids)
    if @orders.any? {|order| order.updated_at < time}
      raise "error"
    else
      Notifier.job_completed(@orders).delay
    end
  end
end