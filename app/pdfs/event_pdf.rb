class EventPdf < Prawn::Document
  def initialize(event, line_items, view)
    super(top_margin: 70)
    @event = event
    @view = view
    @line_items = line_items
    event_number
    promoter
    items
    # total_price

  end

  def event_number
    text "#{@event.artist}, #{@event.venue}, #{@event.date}. ", size: 30, style: :bold
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
    [["Name", "Email", "Admit", "Price"]] +
    @line_items.all.map do |item|
      [item.order.name, item.order.email, item.quantity, price(item.order.total)]
    end
  end

  def price(num)
    @view.number_to_currency(num)
  end

  # def total_price
  #   move_down 15
  #   text "Total Price: #{price(@event.total_price)}", size: 16, style: :bold
  # end

  def promoter
  move_down 20
    text "Promoter: #{User.find_by_id(@event.promoter_id).email}", size: 16
    text "printed at: #{Time.now}"
  end
end