class EmailConfirmationsController < ApplicationController

  def create
    user.confirm! unless user.guest
    redirect_to :back, :notice => "Email confirmation sent."
  end

  def confirm
    @user = User.find_by(email_confirm_token: email_confirm_params[:id])
    if @user.email_confirm_sent_at < 2.hours.ago
      redirect_to events_path, :alert => "Email confirmation has expired, we've sent you a new one."
      @user.confirm!
    elsif @user.update_attributes(params[:user])
      @user.state = :normal
      @user.save!
      cookies[:auth_token] = @user.auth_token
      redirect_to root_path, :notice => "Email has been confirmed."
    else
      redirect_to root_path, :notice => "Email could not be confirmed."
    end
  end

  private

    def email_confirm_params
      params.require(:user).permit(:id)
    end
end