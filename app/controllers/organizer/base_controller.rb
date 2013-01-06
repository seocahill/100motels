class Organizer::BaseController < ApplicationController
  # layout 'organizer'
  before_filter :authorize_admin!

  def index
    @events = Event.where(profile_id: current_user.profile.id).order('created_at DESC').limit(5).includes(:users)
    @requests = Request.where(promoter_id: current_user.id)
    @unread = Request.unread
    @tour_requests = Request.where("promoter_id = ? and state = ? and event_id IS NULL", current_user.id, 0)
    @support_requests = Request.where("promoter_id = ? and state = ? and event_id IS NOT NULL", current_user.id, 0)
    @sales = Order.sales_today.joins(:event).where("profile_id = ?", current_user.profile.id)
  end

end