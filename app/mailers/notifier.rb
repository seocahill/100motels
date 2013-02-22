require 'google-qr'

class Notifier < ActionMailer::Base
  default from: "seo@100motels.com"

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

  def order_cancelled(order_id)
    @order = Order.find(order_id)
    mail to: @order.email, subject: "Your order has been cancelled"
  end

  def private_message(message)
    @message = message
    mail to: message.organizer_email, subject: message.subject, from: message.email
  end

  def job_completed(orders)
    @orders = orders
    organizer = User.find(@orders.first.event.users.first)
    mail to: organizer.profile.email, subject: "your job has been completed"
  end
end
