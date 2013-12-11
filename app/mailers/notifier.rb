class Notifier < ActionMailer::Base
  default from: "seo@100motels.com"

  def event_cancelled(order_ids, message)
    @orders = Order.where(id: order_ids)
    @message = message
    @event = @orders.first.event
    mail to: @orders.pluck(:email), subject: "Your event has been cancelled"
  end

  def group_message(event_id, message)
    @message = message
    @event = Event.find(event_id)
    @orders = @event.orders.not_cancelled
    mail to: @orders.pluck(:email), subject: "A message about your Event"
  end

end
