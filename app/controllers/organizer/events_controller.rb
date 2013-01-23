class Organizer::EventsController < Organizer::BaseController
has_scope :pending, type: :boolean
has_scope :paid, type: :boolean
has_scope :failed, type: :boolean
has_scope :refunded, type: :boolean

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(params[:event])
    @event.event_users.build(user_id: current_user.id, state: :organizer)
    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(@event) }
        format.xml { render xml: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.xml { render xml: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @events = current_user.events
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

  def cancel
    @event = Event.find(params[:id])
    orders = @event.orders.all
    if orders.each { |order| CancelEventOrders.new(@event, order, current_user).cancel_or_refund_order }
      @event.state = :cancelled
      @event.save!
      flash[:notice] = "Event has been cancelled"
      redirect_to [:organizer, @event]
    else
      flash[:error] = "Event could not be cancelled at this time"
      redirect_to [:organizer, @event]
    end
  end

end
