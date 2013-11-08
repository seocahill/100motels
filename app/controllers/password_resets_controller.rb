class PasswordResetsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    user.send_password_reset if user
    redirect_to login_path, :notice => "Email sent with password reset instructions."
  end

  def edit
    @user = User.find_by(password_reset_token: (params[:id]))
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def update
    @user = User.find_by(password_reset_token: params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    elsif @user.update_attributes(reset_password_params)
      @user.state = :normal if @user.state_unconfirmed?
      redirect_to login_path, :notice => "Password has been reset."
    else
      render :edit
    end
  end

  private

    def reset_password_params
      params.require(:user).permit(:state, :password)
    end
end
