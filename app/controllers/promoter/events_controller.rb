class Promoter::EventsController < Promoter::BaseController

  def index
    @events = current_user.events.all(order: "artist")
  end

  def new
    @event = current_user.events.build()
  end

  def create
    @event = Event.new(params[:event])
    if @event.save
      flash[:notice] = "Rock and Roll"
      redirect_to @event
    else
      flash[:alert] = "Event has not been created"
      render :action => "new"
    end
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
    @event = Event.find_by_id(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(params[:event])
      flash[:notice] = "Event has been updated"
      redirect_to @event
    else
      flash[:alert] = "Event has not been updated"
      render :action => "edit"
    end
  end

  def destroy
    @event.destroy
    flash[:notice] = "Event has been deleted"
    redirect_to events_path
  end

  private

end
