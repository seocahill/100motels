class EventsController < ApplicationController
  def index
    @events = Event.all
  end

  def show
    @event = Event.find(params[:id])
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
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    @event.update_attributes(params[:event])
    flash[:notice] = "Event has been updated"
    redirect_to @event
  end

  def destroy
  	
  end
end
