class EventPdf < Prawn::Document
  def initialize(event, orders, view)
    super(top_margin: 70)
    @event = event
    @view = view
    @orders = orders
    event_number
    # organizer
    items

  end

  def event_number
    text "#{@event.artist}, #{@event.venue}, #{@event.date.strftime("%b %d %Y")}. ", size: 30, style: :bold
    text "Total Attending: #{@orders.to_a.sum { |order| order.quantity}}"
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
    [["Name", "Email", "Admit"]] +
    @orders.all.map do |item|
      [item.name, item.email, item.quantity]
    end
  end

  def price(num)
    @view.number_to_currency(num)
  end

  # def organizer
  # move_down 20
  #   t = Time.now
  #   text "Organizer: #{@event.profile.user.email}", size: 16
  #   text "printed on: #{t.strftime("%m/%d/%Y")}"
  #   text "at: #{t.strftime("%I:%M%p")}"
  # end
end