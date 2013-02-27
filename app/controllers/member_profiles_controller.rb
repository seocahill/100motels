class MemberProfilesController < ApplicationController
  def new
    @member_profile = MemberProfile.new
  end

  def create
    @member_profile = MemberProfile.new(params[:member_profile])
    if @member_profile.save
      if current_user
        current_user.become_member(@member_profile)
      else
        user = User.create! { |u| u.profile = @member_profile }
        cookies[:auth_token] = user.auth_token
      end
      redirect_to root_url, notice: "Thank you for signing up!"
    else
      render "new"
    end
  end

  def edit
    @member_profile = current_user.profile
  end

  def update
    @member_profile = current_user.profile
    @member_profile.update_attributes(params[:member_profile])
    respond_to do |format|
      if @member_profile.update_attributes(params[:member_profile])
        format.html { redirect_to(events_path, :notice => 'Your Account was successfully updated.') }
        format.json { respond_with_bip(@member_profile) }
        format.js
      else
        format.html { render :action => "edit" }
        format.json { respond_with_bip(@member_profile) }
        format.js
      end
    end
  end
end
