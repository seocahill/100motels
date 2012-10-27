class RequestsController < ApplicationController
  def create
    @request = current_user.requests.build(promoter_id: params[:promoter_id], event_id: params[:event_id])
    if @request.save
      flash[:notice] = "Promoter notified."
      redirect_to :back
    else
      flash[:error] = "Promoter not available."
      redirect_to root_url
    end
  end

  def destroy
    @request = current_user.requests.find(params[:id])
    @request.destroy
    flash[:notice] = "Removed request."
    redirect_to :back
  end
end
