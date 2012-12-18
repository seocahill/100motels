class ProfilesController < ApplicationController

  has_scope :promoter_city

  def index
    @profiles = apply_scopes(Profile.where("state > ? and visible = ?", 0, true).page(params[:page]).per_page(9)).all
    @options = Location.joins(:profile).collect(&:city).uniq
  end

  def show
    @profile = Profile.find(params[:id])
    @user = User.find(@profile.user_id)
    @events = @profile.events.page(params[:page]).per_page(4)
    @requests = Request.where('promoter_id = ? and event_id IS NULL', @user.id)
  end

end