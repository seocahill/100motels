class Promoter::BaseController < ApplicationController
  # before_filter :authorize_admin!

  def index
    @events = Event.where(promoter_id: current_user.id).order('created_at DESC').limit(5).includes(:users)
    @requests = Request.where(promoter_id: current_user.id)
    @tour_requests = Request.where("promoter_id = ? and state = ? and event_id IS NULL", current_user.id, 0)
    @support_requests = Request.where("promoter_id = ? and state = ? and event_id IS NOT NULL", current_user.id, 0)
    # @sales = Event.where(promoter_id: current_user.id).map(&:orders).limit(5)
  end

end