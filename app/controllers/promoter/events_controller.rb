class Promoter::EventsController < Promoter::BaseController

  def index
    @events = current_user.events.all(order: "artist")
  end

  def new
    @event = current_user.events.build()
  end

  def create

  end

  def show
    @event = Event.find_by_id(params[:id])
    @line_items = @event.line_items.includes(:order).page(params[:page])
    @line_items_no_pages = @event.line_items.includes(:order)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = EventPdf.new(@event, @line_items_no_pages, view_context)
        send_data pdf.render, filename: "#{@event.artist}_#{@event.date}.pdf",
                              type: "application/pdf",
                              disposition: "inline"

      end
    end
  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

end
