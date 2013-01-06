class Organizer::ProfilesController < Organizer::BaseController

  has_scope :organizer_city

  def index
    @user_profiles = apply_scopes(User.joins(:profile).where("state > ? and visible = ?", 0, true).page(params[:page]).per_page(3)).all
    @options = Location.joins(:user => :profile).map(&:city)
  end

  def new
    @profile = current_user.create_profile
    if @profile.save
      flash[:notice] = "Profile Created"
      redirect_to [:organizer, @profile]
    else
      flash[:alert] = "profile has not been created"
      render :action => "new"
    end
  end

  def create
    @profile = current_user.create_profile
    if @profile.save
      flash[:notice] = "Profile Created"
      redirect_to [:organizer, @profile]
    else
      flash[:alert] = "profile has not been created"
      render :action => "new"
    end
  end

  def show
    @profile = Profile.find(params[:id])
    @user = User.find(@profile.user_id)
    @events = @profile.events
    @requests = Request.where('promoter_id = ? and event_id IS NULL', @user.id)
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def update
    profile = Profile.find(params[:id])
    if params[:content]
      profile.promoter_name = params[:content][:name][:value]
      profile.available = params[:content][:available][:value]
      profile.fee = params[:content][:fee][:value]
      profile.about = params[:content][:about][:value]
      profile.equipment = params[:content][:equipment][:value]
      profile.venues = params[:content][:venues][:value]
      profile.travel = params[:content][:travel][:value]
      profile.accomodation = params[:content][:accomodation][:value]
      profile.save!
      render text: ""
    elsif profile.update_attributes(params[:profile])
      flash[:notice] = "Event has been updated"
      redirect_to profile
    else
      flash[:alert] = "Event has not been updated"
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
