class Promoter::ProfilesController < Promoter::BaseController

  has_scope :promoter_city

  def index
    @user_profiles = apply_scopes(User.joins(:profile).where("state > ? and visible = ?", 0, true).page(params[:page]).per_page(3)).all
    @options = Location.joins(:user => :profile).map(&:city)
  end

  def new
    @profile = current_user.build_profile
  end

  def create
    @profile = current_user.create_profile
    if @profile.save
      flash[:notice] = "Profile Created"
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
    @requests = Request.where('promoter_id = ? and event_id IS NULL', @profile.user_id)
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def update
    @profile = Profile.find(params[:id])
    if @profile.update_attributes(params[:profile])
      flash[:notice] = "profile has been updated"
      redirect_to [:promoter, @profile]
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
