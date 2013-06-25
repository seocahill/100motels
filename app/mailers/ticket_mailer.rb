require 'google-qr'

class Ticket_Mailer < ActionMailer::Base
  default from: "seo@100motels.com"

  def ticket(order_id, ticket_id)
    @ticket = Ticket.find(ticket_id)
    @order = Order.find(order_id)
    @qr = @ticket.number.to_qr_image(:size => "170x170")
    @event = Event.find(@order.event_id)
    @greeting = "Thanks #{@order.name}!"
    mail to: @order.email, subject: "Your Tickets 100 Motels"
  end
end