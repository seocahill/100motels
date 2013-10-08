class EventsController < ApplicationController
  before_filter :find_event, only: [:show, :update]

  def index
    @events = Event.text_search(params[:query]).page(params[:page]).per_page(9)
  end

  def show
    @order = Order.new
    @message = Message.new
    @organizer = UserDecorator.decorate(@event.user)
  end

  def update
    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event, :notice => 'event was successfully updated.') }
        format.json { respond_with_bip(@event) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@event) }
      end
    end
  end

private

  def find_event
    @event = Event.find(params[:id]).decorate
    rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The event you were looking for" +
    " could not be found"
    redirect_to events_path
  end
end
