require 'google-qr'

class Notifier < ActionMailer::Base
  default css: [:email, :mail_bootstrap], from: "admin@100motels.com"

  def order_processed(order)
    @order = order
    @qr = @order.stripe_customer_token.to_qr_image(:size => "170x170")
    @event = Event.find(order.event_id)
    @greeting = "Thanks #{order.name}!"
    mail to: order.email, subject: "Your Order from 100 Motels"
  end

require 'mail_view'
  class Preview < MailView
    def order_processed
      order = Order.last
      Notifier::Preview::Notifier.order_processed(order)
    end
  end

end
