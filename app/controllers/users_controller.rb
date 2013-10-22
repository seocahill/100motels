class UsersController < ApplicationController

  def show
    @user = User.new
  end

  def new
    @user = User.new
  end

  def create
    @user = params[:user] ? User.new(user_params) : User.new_guest
    if @user.save
      current_user.move_to(@user) if current_user && current_user.guest?
      cookies[:auth_token] = @user.auth_token
      flash[:notice] = @user.guest? ? 'Welcome Guest!' : 'Thank you for signing up!'
      redirect_to public_event_path(@user.events.first) || @user
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
