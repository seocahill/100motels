class UsersController < ApplicationController
  def index
    if current_user
      flash.keep(:notice)
      flash.keep(:error)
      redirect_to user_path(current_user)
    else
      redirect_to signup_path, notice: "Fucks sake"
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = params[:user] ? User.new(params[:user]) : User.new_guest
    if @user.save
      if params[:remember_me]
        cookies.permanent[:auth_token] = @user.auth_token
      else
        cookies[:auth_token] = @user.auth_token
      end
      flash[:notice] = @user.guest? ? 'Welcome Guest!' : 'Thank you for signing up!'
      redirect_to @user.events.first || @user
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

  def stripe_disconnect
    current_user.api_key = nil
    current_user.save!
    redirect_to root_path, notice: "Stipe API key reset"
  end

  private
    def user_params
      params.require(:user).permit(:name, :email)
    end
end
