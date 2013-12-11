class UserMailer < ActionMailer::Base
  default from: "noreply@100motels.com"

  def password_reset(user_id)
    @user = User.find(user_id)
    mail :to => @user.email, :subject => "Password Reset"
  end

  def email_confirmation(user_id)
    @user = User.find(user_id)
    mail :to => @user.email, :subject => "Please confirm your email address"
  end

end
