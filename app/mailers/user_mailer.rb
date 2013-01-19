class UserMailer < ActionMailer::Base
  default from: "seo@100motels.com"

  def password_reset(member)
    @member_profile = member
    mail :to => member.email, :subject => "Password Reset"
  end
end
