class Notifier < ActionMailer::Base
  default from: "seo@100motels.com"

  def event_cancelled(order_id, message)
    @order = Order.find(order_id)
    @message = message
    mail to: @order.email, subject: "Your event has been cancelled"
  end

  def group_message(event_id, message)
    @message = message
    @event = Event.find(event_id)
    @orders = @event.orders.not_cancelled
    mail to: @orders.pluck(:email), subject: "A message about your Event"
  end

end
