class PagesController < ApplicationController
  #before_filter :authorize_admin!



  def home
    @current_address = (request.location.city.empty? && "Vancouver") || request.location.city
    locations = Location.near(@current_address, 30000, order: :distance).limit(6)
    @events = locations.map{ |l| l.event }.uniq unless locations.nil?
    @users = User.with_role(:promoter)
  end

  def info
    # render :layout => 'info'
  end
end
