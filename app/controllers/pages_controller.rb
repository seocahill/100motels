class PagesController < ApplicationController
  layout 'landing', only: [:index]
  def home
    @events = Event.where("events.state > 0 and events.state < 3").uniq.limit(6)
  end

  def info
  end

  def index
    @event = Event.new
  end
end
