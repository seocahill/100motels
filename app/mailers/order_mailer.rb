class OrderMailer < ActionMailer::Base
  default from: "seo@100motels.com"
          # ,return_path: "service@example.com"

  def event_deferred(event_id, message)
    @message = message.message || ""
    @date = message.date
    @event = Event.find(event_id)
    mail bcc: @event.orders.pending.pluck(:email), subject: "100 Motels - Event Deferred"
  end

  def order_created(order_id)
    @order = Order.find(order_id)
    mail to: @order.email, subject: "Your 100 Motels Order"
  end
end
