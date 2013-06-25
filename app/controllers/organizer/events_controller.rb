class Organizer::EventsController < Organizer::BaseController

  def index
    if current_user.events
      redirect_to organizer_event_path(current_user.events.last)
    else
      redirect_to new_organizer_event_path, notice: "You need to create an Event to get started!"
    end
  end

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
    @event = Event.find(params[:id]).decorate
    @events = current_user.events.where("events.state < 4")
    @tickets = @event.tickets.order('quantity_counter, updated_at').joins(:order).where("stripe_event = 2 OR stripe_event = 4")
    @organizer = User.includes(:event_users).where("event_users.event_id = ? AND event_users.state = 3", @event.id).first
    @orders = Order.text_search(params[:query]).page(params[:page]).per_page(15).where(event_id: @event.id)
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
    if event.orders.empty?
      event.state = :cancelled
    else
      CancelEventOrders.new(event.orders).cancel_orders
    end
    event.save!
    redirect_to [:organizer, event], notice: "Your Event has been Cancelled"
  end

  def defer_or_cancel
    event = Event.find(params[:id])
    if params[:name] == "cancel"
      CancelEventOrders.new(event.orders, params).cancel_orders
      flash[:notice] = "Your Event has been Cancelled"
    else
      event.defer_event(params)
      flash[:notice] = "Your Event will be Deferred"
    end
    redirect_to [:organizer, :event]
  end

  def duplicate
    event = Event.find(params[:id])
    event.duplicate(current_user)
    redirect_to @event, notice: "A copy of your event was created successfully"
  end

  def admit
    event = Event.find(params[:id])
    ticket = Ticket.find_by_number(params[:query])
    if ticket.present? and [:paid, :tickets_sent, :refunded].include? ticket.order.stripe_event
      if ticket.admitted.nil?
         ticket.admitted = Time.now
         ticket.save!
         flash[:notice] = "Ok! Let them in"
      else
         flash[:error] = "Already Admitted at #{ticket.admitted}"
      end
    else
      flash[:error] = "Ticket not found!" unless params[:query].nil?
    end
    respond_to do |format|
      format.html { redirect_to [:organizer, event] }
      format.js
    end
  end

end
