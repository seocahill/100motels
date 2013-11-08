class EmailConfirmationsController < ApplicationController

  def create
    user.confirm! unless user.guest
    redirect_to :back, :notice => "Email confirmation sent."
  end

  def confirm
    @user = User.find_by(confirmation_token: params[:id])
    if @user.confirmation_sent_at < 2.hours.ago
      redirect_to events_path, :alert => "Email confirmation has expired, we've sent you a new one."
      @user.confirm!
    else
      @user.state = :normal
      @user.events.update_all(state: 1)
      @user.save!
      cookies[:auth_token] = @user.auth_token
      redirect_to root_path, :notice => "Email has been confirmed."
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, :notice => "Couldn't find user record."
  end
end