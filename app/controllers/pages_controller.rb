class PagesController < ApplicationController
  #before_filter :authorize_admin!



  def home
    @location = (request.location.city.empty? && "Vancouver") || request.location.city
    @locations = Location.near(@location, 300, order: :distance).joins(:event).limit(6)
    @events = Event.limit(6)
    @users = User.with_role(:promoter)
    @profiles = Profile.where("state > ? and visible = ?", 0, true).limit(8)
  end

  def info
  end
end
