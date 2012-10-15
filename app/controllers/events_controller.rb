class EventsController < ApplicationController

  # before_filter :authorize_admin!, :except => [:index, :show]
  before_filter :find_event, :only => [:show]

  def index
    @events = Event.text_search(params[:query]).page(params[:page]).per_page(3)
  end

  def show
    @cart = current_cart
    @order = Order.new
    @line_item = LineItem.new
    @promoter = User.find_by_id(@event.promoter_id)
  end

  def mercury_update
    event = Event.find(params[:id])
    event.about = params[:content][:event_about][:value]
    event.save!
    render text: ""
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
