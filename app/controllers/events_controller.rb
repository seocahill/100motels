class EventsController < ApplicationController

  before_filter :find_event, only: [:show, :update]


  has_scope :tonight , type: :boolean
  has_scope :week_end , type: :boolean
  has_scope :month_end , type: :boolean
  has_scope :event_city

  def index
    @options = Location.joins(:event).where("events.state > 0 and events.state < 3").where('events.visible is true').map(&:city).uniq
    @events = apply_scopes(Event.visible.text_search(params[:query]).page(params[:page]).per_page(9))
  end

  def show
    @order = Order.new
    @organizer = UserDecorator.decorate(@event.users.first) #ok for now
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
