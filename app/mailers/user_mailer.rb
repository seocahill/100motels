class UserMailer < ActionMailer::Base
  default from: "seo@100motels.com"

  def password_reset(member_id)
    @member_profile = MemberProfile.find(member_id)
    mail :to => @member_profile.email, :subject => "Password Reset"
  end

  def email_confirmation(member_id)
    @member_profile = MemberProfile.find(member_id)
    mail :to => @member_profile.email, :subject => "Please confirm your email address"
  end

  def event_admin_invite(member_id, inviter_id, event_id)
    @member_profile = MemberProfile.find(member_id)
    @event = Event.find(event_id)
    @inviter = User.find(inviter_id)
    mail :to => @member_profile.email, :subject => "100 Motels - You have been added as an Event Administrator"
  end

  def event_admin_notification(member_id, inviter_id, event_id)
    @member_profile = MemberProfile.find(member_id)
    @event = Event.find(event_id)
    @inviter = User.find(inviter_id)
    mail :to => @member_profile.email, :subject => "100 Motels - You have been added as an Event Administrator"
  end
end
