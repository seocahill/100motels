class PagesController < ApplicationController
  #before_filter :authorize_admin!



  def home
    locations = Location.near("Vancouver, Canada", 3000, order: :distance)
    @events = locations.map{ |l| l.event }.uniq unless locations.nil?
    # @events = Event.all
    @users = User.all(order: :email, limit: 4)
  end

  def info
    # render :layout => 'info'
  end
end
