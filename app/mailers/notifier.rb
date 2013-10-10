class Notifier < ActionMailer::Base
  default from: "seo@100motels.com"

  def event_cancelled(order_id, message)
    @order = Order.find(order_id)
    @message = message
    mail to: @order.email, subject: "Your event has been cancelled"
  end

  def private_message(message)
    @message = message
    mail to: message.admin_email, subject: message.subject, from: message.email
  end

  def group_message(message, order)
    @message = message
    @order = order
    mail to: order.email, subject: message.subject, from: message.email
  end

  def job_completed(orders)
    @orders = orders
    event = @orders.first.event
    admin = User.includes(:event_users).where("event_users.event_id = ? AND event_users.state = 3", event.id).first
    mail to: admin.profile.email, subject: "your job has been completed"
  end
end
