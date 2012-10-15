class Promoter::ProfilesController < Promoter::BaseController

  def show
    @user = User.find(params[:id])
    @events = Event.where(@user.id == :promoter_id)
  end

  def index
    @users = User.with_role(:promoter).page(params[:page]).per_page(3)
  end

end
