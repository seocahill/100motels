class EventsController < ApplicationController
  def index
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
  	@event = Event.new
	end

  def create
  	@event = Event.new(params[:event])
    @event.save
    flash[:notice] = "Rock and Roll"
    redirect_to @event
  end

  def edit
  	
  end

  def update
  	
  end

  def destroy
  	
  end
end
