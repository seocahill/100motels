class PagesController < ApplicationController

  def home
    @location ||= calculate_location
    # @locations = Location.joins(:event).where("events.state > 0 and events.state < 3").uniq.limit(6)
    @events = Event.where("events.state > 0 and events.state < 3").uniq.limit(6)
    @profiles = Profile.where("state > ? and visible = ?", 0, true).limit(8)
  end

  def info
  end
end
