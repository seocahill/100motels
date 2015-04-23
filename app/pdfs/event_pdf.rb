class EventPdf < Prawn::Document

  def initialize(event, orders)
    super(top_margin: 70)
    @event = event
    @orders = orders
    event_number
    items
    line_item_rows
  end

  def event_number
    text "#{@event.name}", size: 30, style: :bold
    text "#{@event.date.strftime("%b %d %Y")} in #{@event.location}", size: 20, style: :bold
    text "Total Orders: #{@orders.count}"
  end

  def items
    move_down 20
    table line_item_rows do
      row(0).font_style = :bold
      columns(2..3).align = :center
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def line_item_rows
    [[ "Name", "Email", "Quantity", "Card", "Status", "Net", "Gross"]] +
    @orders.map do |order|
      [order.name, order.email, order.quantity, order.last4, order.stripe_event.to_s, order.quantity * order.ticket_price, order.total]
    end
  end
end
