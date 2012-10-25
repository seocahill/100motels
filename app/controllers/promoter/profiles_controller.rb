class Promoter::ProfilesController < Promoter::BaseController


  def index
    @users = User.with_role(:promoter).page(params[:page]).per_page(3)
  end

  def new
    @profile = current_user.build_profile
  end

  def create
    @profile = current_user.build_profile(params[:profile])
    if @profile.save
      flash[:notice] = "Rock and Roll"
      redirect_to [:promoter, @profile]
    else
      flash[:alert] = "profile has not been created"
      render :action => "new"
    end
  end

  def show
    @profile = Profile.find(params[:id])
    @user = User.find(@profile.user_id)
    @events = Event.where(@user.id == :promoter_id)
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def update
    @profile = profile.find(params[:id])
    if @profile.update_attributes(params[:profile])
      flash[:notice] = "profile has been updated"
      redirect_to @profile
    else
      flash[:alert] = "profile has not been updated"
      render :action => "edit"
    end
  end

  def destroy
    @profile = profile.find(params[:id])
    @profile.destroy
    flash[:notice] = "profile has been deleted"
    redirect_to root_path
  end
end
