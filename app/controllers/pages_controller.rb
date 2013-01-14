class PagesController < ApplicationController

  def home
    @events = Event.where("events.state > 0 and events.state < 3").uniq.limit(6)
  end

  def info
  end
end
