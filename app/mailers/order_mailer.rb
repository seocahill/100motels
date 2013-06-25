class OrderMailer < ActionMailer::Base
  default from: "from@example.com"

  def event_deferred(order, params)
    @order = order
    @message = params[:alter_event][:message]
    @new_date = params[:alter_event][:date]
    mail to: order.email, subject: "100 Motels - Event Deferred"
  end
end
