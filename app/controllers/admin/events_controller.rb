class Admin::EventsController < Admin::BaseController
  before_action :signed_in?
  before_action only: [:show, :edit, :update, :destroy] do
    authorized?(params[:id])
  end

  def index
    @event = current_user.events.first
    redirect_to admin_event_path(@event)
  end


  def show
    @event = Event.find(params[:id])
    @presenter = EventPresenter.new(view_context)
    @events = current_user.events
    @orders = @event.orders.text_search(params[:query]).page(params[:page]).per_page(15)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = EventPdf.new(@event, @orders)
        send_data pdf.render, filename: "#{@event.name}_#{@event.date}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def new
    @event = current_user.events.present? ? current_user.events.last.dup : Event.new
  end

  def create
    @event = current_user.events.new(event_params)
    if @event.save
      flash[:notice] = 'Event was successfully created.'
      redirect_to(@event)
    else
      render action: "new"
    end
  end

  def edit
    @event = Event.find(params[:id])
  end


  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(event_params)
      flash[:notice] = "Event has been updated"
      redirect_to [:admin, @event]
    else
      render action: "edit"
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if @event.orders.empty?
      @event.state = :destroyed
    else
      CancelEventOrders.new(@event.orders).cancel_orders
    end
    @event.save!
    redirect_to [:admin, event], notice: "Your Event has been Cancelled"
  end


  private

  def event_params
    params.require(:event).permit(:name, :location, :date, :ticket_price, :visible, :target, :about, :image, :time)
  end
end
