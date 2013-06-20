class OrderMailer < ActionMailer::Base
  default from: "from@example.com"

  def event_deferred(order)
    mail to: order.email
  end
end
