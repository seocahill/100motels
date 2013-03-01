class EmailConfirmationsController < ApplicationController

  def create
    member = current_user.profile
    member.confirm! if member
    redirect_to :back, :notice => "Email confirmation sent."
  end

  def confirm
    @member_profile = MemberProfile.find_by_email_confirm_token!(params[:id])
    if @member_profile.email_confirm_sent_at < 2.hours.ago
      redirect_to events_path, :alert => "Email confirmation has expired, we've sent you a new one."
      @member_profile.confirm!
    elsif @member_profile.update_attributes(params[:member_profile])
      @member_profile.user.state = :normal
      @member_profile.save!
      redirect_to events_path, :notice => "Email has been confirmed."
    else
      redirect_to events_path, :notice => "Email could not be confirmed."
    end
  end
end