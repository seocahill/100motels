class Promoter::BaseController < ApplicationController
  # before_filter :authorize_admin!

  def index
    @events = Event.where(promoter_id: current_user.id).includes(:users)
  end

  def requests
    @events = Event.where(promoter_id: current_user.id).includes(:users)
    # @tour_requests =
    #
  end

end