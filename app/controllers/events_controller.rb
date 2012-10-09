class EventsController < ApplicationController

  before_filter :authorize_admin!, :except => [:index, :show]
  before_filter :find_event, :only => [:update, :show, :edit, :destroy]

  def index
    @events = Event.all
    @cart = current_cart
  end

  def show
    @cart = current_cart
    @line_item = LineItem.new
  end

  def new
	end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
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
