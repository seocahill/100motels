module OrdersHelper
  def get_promoter
    id = @order.line_items.first.event_id
    event = Event.find_by_id(id)
    promoter = User.find_by_id(event.promoter_id)
  end
end
