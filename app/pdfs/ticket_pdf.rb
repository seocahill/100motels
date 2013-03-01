class TicketPdf < Prawn::Document
  def initialize(event, tickets, view)
    super(top_margin: 70)
    @event = event
    @view = view
    @tickets = tickets
    event_number
    organizer
    items

  end

  def event_number
    text "#{@event.title}, #{@event.venue}, #{@event.date.strftime("%b %d %Y")}. ", size: 30, style: :bold
    text "Total Attending: #{@tickets.count}"
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
    [["Name", "Email", "Ticket Number", "\#", "Admitted?" ]] +
    @tickets.all.map do |t|
      [t.order.name, t.order.email, t.number, t.quantity_counter, ""]
    end
  end

  def organizer_email
    if @view.current_user.guest?
      "Guest"
    else
      @view.current_user.profile.email
    end
  end

  def organizer
  move_down 20
    t = Time.now
    text "Organizer: #{self.organizer_email}", size: 16
    text "printed on: #{t.strftime("%m/%d/%Y")}"
    text "at: #{t.strftime("%I:%M%p")}"
  end
end