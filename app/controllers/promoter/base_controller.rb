class Promoter::BaseController < ApplicationController
  # before_filter :authorize_admin!

  def index
    @events = current_user.events
    @support_requests = @events.map {|e| e.users}
  end

  def requests
    @events = current_user.events.includes(:users)
    # @tour_requests =
    @support_requests = current_user.events
  end

end