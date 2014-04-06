class Admin::UsersController < Admin::BaseController

  def show
    @user = current_user
    @event = Event.find(params[:event_id])
    @presenter = EventPresenter.new(view_context)
  end
end