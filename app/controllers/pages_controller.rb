class PagesController < ApplicationController
  #before_filter :authorize_admin!

  def home
    @location ||= calculate_location
    @locations = Location.near(@location, 30000, order: :distance).joins(:event).uniq.limit(6)
    @events = Event.limit(6)
    @users = User.with_role(:promoter)
    @profiles = Profile.where("state > ? and visible = ?", 0, true).limit(8)
    @seo = User.find(1)
  end

  def info
    @seo = User.find(1)
  end
end
