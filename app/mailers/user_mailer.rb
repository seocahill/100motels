class UserMailer < ActionMailer::Base
  default from: "seo@100motels.com"

  def password_reset(member)
    @member_profile = member
    mail :to => member.email, :subject => "Password Reset"
  end

  def email_confirmation(member)
    @member_profile = member
    mail :to => member.email, :subject => "Please confirm your email address"
  end
end
