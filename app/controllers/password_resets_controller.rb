class PasswordResetsController < ApplicationController

  def new
  end

  def create
    member = MemberProfile.find_by_email(params[:email])
    member.send_password_reset if member
    redirect_to events_path, :notice => "Email sent with password reset instructions."
  end

  def edit
    @member_profile = MemberProfile.find_by_password_reset_token!(params[:id])
  end

  def update
    @member_profile = MemberProfile.find_by_password_reset_token!(params[:id])
    if @member_profile.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Password reset has expired."
    elsif @member_profile.update_attributes(params[:member_profile])

      redirect_to events_path, :notice => "Password has been reset."
    else
      render :edit
    end
  end
end
