require 'google-qr'

class Notifier < ActionMailer::Base
  default css: [:email, :mail_bootstrap], from: "sales@100motels.com"

  def order_processed(order)
    @order = order
    @event = Event.find(order.event_id)
    @greeting = "Thanks #{order.name}!"
    mail to: order.email, subject: "Your Order from 100 Motels"
  end

  def ticket(order)
    @order = order
    @qr = @order.stripe_charge_id.to_qr_image(:size => "170x170")
    @event = Event.find(order.event_id)
    @greeting = "Thanks #{order.name}!"
    mail to: order.email, subject: "Your Tickets 100 Motels"
  end

  def transaction_summary(orders, organizer)
    @orders = orders
    @organizer = organizer
    mail to: @organizer.email, subject: "Transaction Summary"
  end

require 'mail_view'
  class Preview < MailView
    def order_processed
      order = Order.last
      Notifier::Preview::Notifier.order_processed(order)
    end

    def ticket
      order = Order.find(163)
      Notifier::Preview::Notifier.ticket(order)
    end

    def transaction_summary
      orders = Order.find([177, 178, 179, 180, 181, 152, 168, 171, 170, 153])
      organizer = User.find(1)
      Notifier::Preview::Notifier.ticket(orders, organizer)
    end
  end
end
