class PasswordConfirmationsController < ApplicationController

  def create
    member = current_user.member_profile
    member.confirm if member
    redirect_to :back, :notice => "Email confrimation sent."
  end

  def update
    @member_profile = MemberProfile.find_by_email_confirm_token!(params[:id])
    if @member_profile.email_confimr_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => "Email confirmation has expired."
    elsif @member_profile.update_attributes(params[:member_profile])
      redirect_to events_path, :notice => "Email has been confirmed."
    else
      render :edit
    end
  end
end