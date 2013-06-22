class Organizer::EventsController < Organizer::BaseController
has_scope :pending, type: :boolean
has_scope :paid, type: :boolean
has_scope :tickets_sent, type: :boolean
has_scope :failed, type: :boolean
has_scope :refunded, type: :boolean

  def new
    @event = Event.new
  end

  def create
    state = current_user.guest? ? :guest : :member
    @event = Event.new(params[:event].merge(state: state))
    @event.event_users.build(user_id: current_user.id, state: :event_admin)
    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(@event) }
        format.xml { render xml: @event, status: :created, location: @event }
      else
        flash[:error] = "Event couldn't be created."
        format.html { render action: "new" }
        format.xml { render xml: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @events = current_user.events.where("events.state < 4")
    @event = Event.find(params[:id])
    @decorated_event = Event.find(params[:id]).decorate
    @organizer = User.includes(:event_users).where("event_users.event_id = ? AND event_users.state = 3", @event.id).first
    @orders = Order.text_search(params[:query]).page(params[:page]).per_page(15).where(event_id: @event.id)
    @tickets = @event.tickets.order('quantity_counter, updated_at').joins(:order).where("stripe_event = 2 OR stripe_event = 4")
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

  def destroy
    event = Event.find(params[:id])
    orders = event.orders.all
    if orders.empty?
      event.destroy
      redirect_to root_path, notice: "Event deleted"
    else
      if CancelEventOrders.new(orders).cancel_orders
        event.state = :cancelled
        event.save!
        orders.each { |order| Notifier.delay_for(30.minutes).event_cancelled(order.id) }
        flash[:notice] = "Event has been cancelled"
      else
        flash[:error] = "Event could not be cancelled at this time"
      end
      redirect_to [:organizer, event]
    end
  end

  def defer
    event = Event.find(params[:id])
    event.defer_event(params)
    flash[:notice] = "Your Event will be Deferred"
    redirect_to :back
  end

  def duplicate
    original = Event.find(params[:id])
    location = request.location.present? ? request.location.address : original.location.address
    @event = original.dup
    @event.title = "Copy of #{original.title}"
    @event.state = current_user.guest? ? :guest : :member
    @event.event_users.build(user_id: current_user.id, state: :event_admin)
    @event.build_location(address: location)
    @event.save!
    redirect_to @event, notice: "A copy of your event was created successfully"
  end

end
