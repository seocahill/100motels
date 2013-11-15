class UsersController < ApplicationController
  before_action :signed_in?, only: [:show, :update]

  def show
    @user = User.new
  end

  def new
    @user = User.new
  end

  def create
    @user = params[:user] ? User.new(user_params) : User.new_guest
    if @user.save
      if current_user && current_user.guest?
        current_user.move_to(@user)
      else
        @user.guest_user_event
      end
      cookies[:auth_token] = @user.auth_token
      flash[:notice] = @user.guest? ? 'Welcome Guest!' : "Thanks for signing up! We've sent you an email to confirm your password"
      redirect_to @user
    else
      render action: "new"
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.authenticate(params[:confirm_password])
      if @user.update_attributes(user_params)
        redirect_to @user, notice: "Settings updated"
      end
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
