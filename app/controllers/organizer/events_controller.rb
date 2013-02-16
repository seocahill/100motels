class Organizer::EventsController < Organizer::BaseController
has_scope :pending, type: :boolean
has_scope :paid, type: :boolean
has_scope :failed, type: :boolean
has_scope :refunded, type: :boolean

  def new
    @event = Event.new
  end

  def create
    state = current_user.guest? ? :guest : :member
    @event = Event.new(params[:event].merge(state: state))
    @event.event_users.build(user_id: current_user.id)
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
    @events = current_user.events
    @event = Event.find_by_id(params[:id])
    @orders = apply_scopes(Order.text_search(params[:query]).page(params[:page]).per_page(10)).where(event_id: @event.id)
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
    event = Event.find(params[:id])
    orders = event.orders.all
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
