class EventsController < ApplicationController
  before_action :find_event, only: [:show]


  def index
    @events = Event.text_search(params[:query]).page(params[:page]).per_page(9).where("visible = true").includes(:user).where("state = 1").decorate
  end

  def show
    @order = Order.new
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
    @event = Event.find(params[:id]).decorate
    if @event.visible or authorized?(params[:id])
      @event
    else
      nil
    end
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The event you were looking for could not be found"
    redirect_to events_path
  end
end
