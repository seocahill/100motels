class Organizer::EventUsersController < ApplicationController

  def index
    @event = Event.find(params[:event_id])
    @event_users = @event.event_users.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @event_users }
    end
  end

  # GET /event_users/1
  # GET /event_users/1.json
  def show
    @event = Event.find(params[:event_id])
    @event_user = EventUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.js
    end
  end

  # GET /event_users/new
  # GET /event_users/new.json
  def new
    @event = Event.find(params[:event_id])
    @event_user = EventUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @event_user }
      format.js
    end
  end

  # GET /event_users/1/edit
  def edit
    @event = Event.find(params[:event_id])
    @event_user = EventUser.find(params[:id])
  end

  def create
    @event = Event.find(params[:event_id])
    invite = Invitation.new(params, current_user.id)
    respond_to do |format|
      if invite.exiting_user?
        format.html { redirect_to organizer_event_event_users_path(@event), notice: 'Event user was successfully created.' }
        format.js
      else
        format.html { redirect_to :back, notice: 'Something went wrong' }
        format.js
      end
    end
  end

  # PUT /event_users/1
  # PUT /event_users/1.json
  def update
    @event = Event.find(params[:event_id])
    @event_user = EventUser.find(params[:id])
    respond_to do |format|
      if @event_user.update_attributes(params[:event_user])
        format.html { redirect_to @event_user, notice: 'Event user was successfully updated.' }
        format.json { respond_with_bip(@event_user) }
      else
        format.html { render action: "edit" }
        format.json { respond_with_bip(@event_user) }
      end
    end
  end

  # DELETE /event_users/1
  # DELETE /event_users/1.json
  def destroy
    @event = Event.find(params[:event_id])
    @event_user = EventUser.find(params[:id])
    @event_user.destroy

    respond_to do |format|
      format.html { redirect_to event_users_url }
      format.js
    end
  end
end
