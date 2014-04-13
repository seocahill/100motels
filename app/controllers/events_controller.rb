class EventsController < ApplicationController
  before_action :find_event, only: [:show]

  def index
    @events = Event.where(visible: true).text_search(params[:query]).page(params[:page]).per_page(6)
    @presenter = EventPresenter.new(view_context)
    fresh_when last_modified: @events.maximum(:updated_at)
  end

  def show
    @order = Order.new
    @presenter = EventPresenter.new(view_context)
  end

  def update
    @event = Event.find(params[:id])
    respond_to do |format|
      if @event.update_attributes(event_params)
        format.html { redirect_to(@event, :notice => 'event was successfully updated.') }
        format.json { respond_with_bip(@event) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@event) }
      end
    end
  end

private

  def event_params
    params.require(:event).permit(:image, :date, :location, :name, :ticket_price, :about)
  end

  def find_event
    @event = Event.find(params[:id])
    raise ActiveRecord::RecordNotFound unless @event.public? or @event.user == current_user
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The event you were looking for could not be found"
    redirect_to root_path
  end
end
