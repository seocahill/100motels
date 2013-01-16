class EventsController < ApplicationController

  before_filter :find_event, :only => [:show, :update]
  respond_to :html, :json

  has_scope :tonight , type: :boolean
  has_scope :week_end , type: :boolean
  has_scope :month_end , type: :boolean
  has_scope :event_city

  def index
    @options = Location.joins(:event).where("events.state > 0 and events.state < 3").collect(&:city).uniq
    @events = apply_scopes(Event.visible.text_search(params[:query]).page(params[:page]).per_page(9))
  end

  def show
    @order = Order.new
    @organizer = User.find(@event.promoter_id)
  end

  def create
    @event = Event.new
    @event.artist = "A Title for your Event"
    @event.venue = "A Dungeon or Speak hopefully"
    @event.date = 1.month.from_now
    @event.ticket_price = 15.0
    @event.promoter_id = current_or_guest_user.id
    @event.save!
    redirect_to @event, notice: "Welcome to your event, you can save this account at any time, click on 'save account' in the top menu"
  end

  def update
    @event.update_attributes(params[:event])
    respond_with @event

  end

private

  def find_event
    @event = Event.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    flash[:alert] = "The event you were looking for" +
    " could not be found"
    redirect_to events_path
  end

end
