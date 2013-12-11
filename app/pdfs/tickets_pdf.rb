class TicketsPdf < Prawn::Document

  def initialize(event, tickets)
    super(top_margin: 70)
    @event = event
    @tickets = tickets
    event_number
    items
    line_item_rows

  end

  def event_number
    text "#{@event.name}", size: 30, style: :bold
    text "#{@event.date.strftime("%b %d %Y")} in #{@event.location}", size: 20, style: :bold
    text "Total Tickets: #{@tickets.count}"
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

  def admitted(ticket)

  end

  def line_item_rows
    [["Number", "Name", "Email", "Card last 4", "Admitted"]] +
    @tickets.map do |ticket|
      checked = ticket.admitted? ? ticket.admitted.strftime("%b %e, %l:%M %p") : ""
      [ticket.number, ticket.order.name, ticket.order.email, ticket.order.last4, checked]
    end
  end
end