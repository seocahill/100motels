require 'mail_view'

class Notifier < ActionMailer::Base
  default from: "admin@100motels.com"

  def order_processed(order)
    @order = order
    @greeting = "Hi #{order.name}!"
    mail to: order.email, subject: "Your Order from 100 Motels"
  end

  def template
  end

  class Preview < MailView
    def order_processed
      order = Order.first
      Notifier.order_processed(order)
    end

    def template
      order = Order.first
      Notifier.template(order)
    end
  end

end
