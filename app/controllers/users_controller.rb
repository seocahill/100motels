class UsersController < ApplicationController
  before_action :signed_in?, only: [:show, :update]

  def show
    @user = current_user
    @presenter = EventPresenter.new(view_context)
  end

  def new
    @user = User.new
  end

  def create
    @user = params[:user] ? User.new(user_params) : User.new_guest
    if @user.save!
      current_user ? current_user.move_to(@user) : @user.guest_user_event
      cookies[:auth_token] = @user.auth_token
      flash[:notice] = @user.guest? ? 'Welcome Guest!' : "Thanks for signing up! We've sent you an email to confirm your password"
      redirect_to(@user.guest? ? @user.events.first : @user)
    else
      render action: "new"
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.authenticate(params[:confirm_password]) and @user.update_attributes(user_params)
      redirect_to(@user, notice: "Settings updated")
    else
      flash[:error] = "You must enter your password to confirm changes"
      render :show
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
