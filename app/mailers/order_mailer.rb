class OrderMailer < ActionMailer::Base
  default from: "seo@100motels.com"

  def event_deferred(order, params)
    @order = order
    @message = params[:alter_event][:message]
    @new_date = params[:alter_event][:date]
    mail to: order.email, subject: "100 Motels - Event Deferred"
  end

  def order_created(order_id)
    @order = Order.find(order_id)
    @event = Event.find(@order.event_id)
    mail to: @order.email, subject: "Your Order from 100 Motels"
  end

  def notify_admin_order_created(order_id)
    @order = Order.find(order_id)
    @event = Event.find(@order.event_id)
    mail to: "ocathais@gmail.com", subject: "Your Order from 100 Motels"
  end

  def charge_failed(order_id)
    @order = Order.find(order_id)
    mail to: @order.email, subject: "We could not complete your order"
  end

  def refund_customer_order(order_id)
    @order = Order.find(order_id)
    mail to: @order.email, subject: "You have been refunded"
  end

  def order_cancelled(order_id)
    @order = Order.find(order_id)
    mail to: @order.email, subject: "Your order has been cancelled"
  end
end
