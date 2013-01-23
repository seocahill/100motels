class EventsController < ApplicationController

  before_filter :find_event, :only => [:show]

  has_scope :tonight , type: :boolean
  has_scope :week_end , type: :boolean
  has_scope :month_end , type: :boolean
  has_scope :event_city

  def index
    @options = Location.joins(:event).where("events.state > 0 and events.state < 3").where('events.visible is true').collect(&:city).uniq
    @events = apply_scopes(Event.visible.text_search(params[:query]).page(params[:page]).per_page(9))
  end

  def show
    @order = Order.new
    @organizer = UserDecorator.decorate(@event.users.first) #ok for now
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

