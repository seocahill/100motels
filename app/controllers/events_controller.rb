class EventsController < ApplicationController

  before_filter :find_event, :only => [:show, :update, :edit]

  has_scope :tonight , type: :boolean
  has_scope :week_end , type: :boolean
  has_scope :month_end , type: :boolean
  has_scope :event_city

  def index
    @options = Location.joins(:event).where("events.state > 0 and events.state < 3").where('events.visible is true').collect(&:city).uniq
    @events = apply_scopes(Event.visible.text_search(params[:query]).page(params[:page]).per_page(9))
  end

  def show
    @order = Order.new
    @organizer = @event.users.first #ok for nowgit s
  end

  def new
    @event = current_user.events.new
  end

  def create
    @event = current_user.events.new(params[:event])
    respond_to do |format|
      if @event.save
        flash[:notice] = 'Event was successfully created.'
        format.html { redirect_to(@event) }
        format.xml { render xml: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.xml { render xml: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    @event.update_attributes(params[:event])
    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event, :notice => 'User was successfully updated.') }
        format.json { respond_with_bip(@event) }
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@event) }
      end
    end
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

