class Organizer::RequestsController < Organizer::BaseController
  before_filter :authorize_admin!

  def index
    @requests = Request.where(promoter_id: current_user.id)
    @unread = Request.unread.where(promoter_id: current_user.id)
  end

end