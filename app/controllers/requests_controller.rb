class RequestsController < ApplicationController

  def index
    @requests = Request.where(promoter_id: current_user.id)
    @unread = Request.unread.where(promoter_id: current_user.id)
  end

  def create
    @request = current_user.requests.build(organizer_id: params[:organizer_id], event_id: params[:event_id])
    if @request.save
      flash[:notice] = "Organizer notified."
      redirect_to :back
    else
      flash[:error] = "Organizer not available."
      redirect_to root_url
    end
  end

  def mark_read
    requests = Request.find(params[:request_ids])
    requests.each { |r| r.state = :read }
    requests.each(&:save)
    redirect_to requests_path, notice: "marked as read and archived"
  end

  def destroy
    @request = current_user.requests.find(params[:id])
    @request.destroy
    flash[:notice] = "Removed request."
    redirect_to :back
  end
end
