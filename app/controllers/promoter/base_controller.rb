class Promoter::BaseController < ApplicationController
  # before_filter :authorize_admin!

  def index
    @events = Event.where(promoter_id: current_user.id).order('created_at DESC').limit(5).includes(:users)
    @requests = Request.where(@events.include?(:event))
    @sales = Order.recent_sales(current_user)
  end

  def requests
    @events = Event.where(promoter_id: current_user.id).includes(:users)
    # @tour_requests =
    @support_requests = current_user.events
  end

end