class EventsController < ApplicationController

  # before_filter :authorize_admin!, :except => [:index, :show]
  before_filter :find_event, :only => [:show]

  has_scope :expensive, type: :boolean
  has_scope :month_end , type: :boolean

  def index
    @location = current_location
    # @events = Event.text_search(params[:query]).page(params[:page]).per_page(3)
    # @locations = Location.where(city: current_location).includes(:event).page(params[:page]).per_page(3)
    @events = apply_scopes(Event).all
  end

  def show
    @order = Order.new
    @promoter = User.find_by_id(@event.promoter_id).profile
  end

  def mercury_update
    event = Event.find(params[:id])
    event.about = params[:content][:event_about][:value]
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
