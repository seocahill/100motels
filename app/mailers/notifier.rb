require 'google-qr'

class Notifier < ActionMailer::Base
  default css: [:email, :mail_bootstrap], from: "seo@100motels.com"

  def order_created(order_id)
    @order = Order.find(order_id)
    mail to: @order.email, subject: "Your Order from 100 Motels"
  end

  def ticket(order_id, ticket_id)
    @ticket = Ticket.find(ticket_id)
    @order = Order.find(order_id)
    @qr = @ticket.number.to_qr_image(:size => "170x170")
    @event = Event.find(@order.event_id)
    @greeting = "Thanks #{@order.name}!"
    mail to: @order.email, subject: "Your Tickets 100 Motels"
  end

  def transaction_summary(orders, email)
    @orders = orders
    @email = email
    mail to: @email, subject: "Transaction Summary"
  end

  def charge_failed(order_id)
    @order = Order.find(order_id)
    mail to: @order.email, subject: "We could not complete your order"
  end

  def refund_customer_order(order_id)
    @order = Order.find(order_id)
    mail to: @order.email, subject: "You have been refunded"
  end

  def event_cancelled(order_id)
    @order = Order.find(order_id)
    mail to: @order.email, subject: "Your event has been cancelled"
  end
end
