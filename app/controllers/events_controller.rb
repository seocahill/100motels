class EventsController < ApplicationController

  before_filter :find_event, :only => [:show]

  has_scope :tonight , type: :boolean
  has_scope :week_end , type: :boolean
  has_scope :month_end , type: :boolean
  has_scope :event_city

  def index
    @options = Location.joins(:event).where("events.state > 0 and events.state < 3").collect(&:city).uniq
    # @location = current_location
    @events = apply_scopes(Event.visible.text_search(params[:query]).page(params[:page]).per_page(3))
  end

  def show
    @order = Order.new
    @promoter = Profile.find(@event.profile_id)
  end

  # def edit
  #   @event = Event.find(params[:id])
  # end

  def update
    event = Event.find(params[:id])
    event.artist = params[:content][:artist][:value]
    event.about = params[:content][:about][:value]
    event.save!
    render text: ""
  end

  def request_support
    event = Event.find(params[:id])
    event.users << current_user
    event.save!
    redirect_to :back, notice: "The Promoter has been notified"
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
