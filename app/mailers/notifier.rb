require 'google-qr'

class Notifier < ActionMailer::Base
  default css: [:email, :mail_bootstrap], from: "sales@100motels.com"

  def order_processed(order)
    @order = order
    @event = Event.find(order.event_id)
    @greeting = "Thanks #{order.name}!"
    mail to: order.email, subject: "Your Order from 100 Motels"
  end

  def ticket(order, ticket)
    @order = order
    @qr = ticket.number.to_qr_image(:size => "170x170")
    @event = Event.find(order.event_id)
    @greeting = "Thanks #{order.name}!"
    mail to: order.email, subject: "Your Tickets 100 Motels"
  end

  def transaction_summary(orders, organizer)
    @orders = orders
    @organizer = organizer
    mail to: @organizer.email, subject: "Transaction Summary"
  end

  def charge_failed(order)
    @order = order
    mail to: order.email, subject: "We could not complete your order"
  end
end
