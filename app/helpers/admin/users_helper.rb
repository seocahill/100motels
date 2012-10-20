module Admin::UsersHelper
  def promoter(order)
    event = Event.find(order.event_id)
    promoter = User.find(event.promoter_id)
    promoter
  end
end
