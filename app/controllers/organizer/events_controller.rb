class Organizer::EventsController < Organizer::BaseController
before_filter :authorize_admin!
  def index
    # @events = Event.where(profile_id: current_user.profile.id)
    @events = current_user.profile.events if current_user.profile
    @profile = current_user.profile
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event])
    @event.profile_id = current_user.profile.id
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
    @orders = @event.orders.order("created_at DESC").page(params[:page]).per_page(10)
    @orders_no_pages = @event.orders
    respond_to do |format|
      format.html
      format.pdf do
        pdf = EventPdf.new(@event, @orders_no_pages, view_context)
        send_data pdf.render, filename: "#{@event.artist}_#{@event.date}.pdf",
                              type: "application/pdf",
                              disposition: "inline"

      end
    end
  end

  def edit
    @event = Event.find(params[:id])
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
    @event = Event.find(params[:id])
    @event.destroy
    flash[:notice] = "Event has been deleted"
    redirect_to organizer_root_path
  end

  private

end
