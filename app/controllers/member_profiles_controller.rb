class MemberProfilesController < ApplicationController
  def new
    @member_profile = MemberProfile.new
  end

  def create
    @member_profile = MemberProfile.new(params[:member_profile])
    if @member_profile.save
      current_user.become_member(@member_profile)
      redirect_to root_url, notice: "Thank you for signing up!"
    else
      render "new"
    end
  end
end
