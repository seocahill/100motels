class Admin::MessagesController < ApplicationController

  def new
    @event = Event.find(params[:event_id])
  end

  def create
    @event = current_user.events.new(event_params)
    if @event.save
      flash[:notice] = 'Event was successfully created.'
      redirect_to(@event)
    else
      flash[:error] = "Event couldn't be created."
      render action: "new"
    end
  end

end
