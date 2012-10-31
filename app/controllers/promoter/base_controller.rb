class Promoter::BaseController < ApplicationController
  # before_filter :authorize_admin!

  def index
    @events = Event.where(profile_id: current_user.profile.id).order('created_at DESC').limit(5).includes(:users)
    @requests = Request.where(profile_id: current_user.profile.id)
    @tour_requests = Request.where("profile_id = ? and state = ? and event_id IS NULL", current_user.profile.id, 0)
    @support_requests = Request.where("profile_id = ? and state = ? and event_id IS NOT NULL", current_user.profile.id, 0)
    @sales = Order.sales_today.joins(:event).where("profile_id = ?", current_user.profile.id)
  end

end