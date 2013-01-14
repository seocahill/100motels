class PagesController < ApplicationController

  def home
    @events = Event.where("events.state > 0 and events.state < 3").uniq.limit(6)
    @profiles = Profile.where("state > ? and visible = ?", 0, true).limit(8)
  end

  def info
  end
end
