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
  	@event = Event.new
	end

  def create
  	@event = Event.new(params[:event])
    if @event.save
      flash[:notice] = "Rock and Roll"
      redirect_to @event
    else
      flash[:alert] = "Event has not been created"
      render :action => "new"
    end

  end

  def edit
  end

  def update
    if @event.update_attributes(params[:event])
      flash[:notice] = "Event has been updated"
      redirect_to @event
    else
      flash[:alert] = "Event has not been updated"
      render :action => "edit"
    end
  end

  def destroy
    @event.destroy
    flash[:notice] = "Event has been deleted"
    redirect_to events_path
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
