class Organizer::EventsController < Organizer::BaseController
before_filter :authorize_admin!
has_scope :pending, type: :boolean
has_scope :paid, type: :boolean
has_scope :failed, type: :boolean
has_scope :refunded, type: :boolean

  def index
    @events = Event.where(promoter_id: current_user.id)
  end

  def new
    @event = Event.new
  end

  def create
    @event = current_user.events.new(params[:event])
    if @event.save
      flash[:notice] = "Event Created Successfully"
      redirect_to @event
    else
      flash[:alert] = "Event has not been created"
      render :action => "new"
    end
  end

  def show
    @events = Event.where(promoter_id: current_user.id)
    @event = Event.find_by_id(params[:id])
    @orders = apply_scopes(Order).where(event_id: @event.id)
    respond_to do |format|
      format.html
      format.pdf do
        pdf = EventPdf.new(@event, @orders, view_context)
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
end
