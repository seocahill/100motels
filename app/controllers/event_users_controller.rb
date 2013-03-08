class EventUsersController < ApplicationController
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
      format.json { render json: @event_user }
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

  # POST /event_users
  # POST /event_users.json
  def create
    @event = Event.find(params[:event_id])
    profile = MemberProfile.find_by_email(params[:email])
    if profile.present?
      @event_user = @event.event_users.new(user_id: profile.user.id, state: params[:state])
    else
    end
    respond_to do |format|
      if @event_user.save
        format.html { redirect_to @event_user, notice: 'Event user was successfully created.' }
        format.json { render json: @event_user, status: :created, location: @event_user }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @event_user.errors, status: :unprocessable_entity }
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
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @event_user.errors, status: :unprocessable_entity }
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
      format.json { head :no_content }
    end
  end
end
