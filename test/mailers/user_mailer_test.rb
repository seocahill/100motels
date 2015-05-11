require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  def setup
    @user = FactoryGirl.create(:user, password_reset_token: "nVEi-279A3uD6CFRU2c-Kg",
      confirmation_token: "oDdkewSXoUMCRAwHcPmgGA/confirm")
  end

  test "password_reset" do
    email = UserMailer.password_reset(@user.id).deliver
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal ['noreply@100motels.com'], email.from
    assert_equal [@user.email], email.to
    assert_equal 'Password Reset', email.subject
    assert_match "http://www.example.com/password_resets/nVEi-279A3uD6CFRU2c-Kg/edit", email.body.to_s
  end

  test "email_confirmations" do
    email = UserMailer.email_confirmation(@user.id).deliver
    assert !ActionMailer::Base.deliveries.empty?
    assert_equal ['noreply@100motels.com'], email.from
    assert_equal [@user.email], email.to
    assert_equal "Please confirm your email address", email.subject
    assert_match /oDdkewSXoUMCRAwHcPmgGA/, email.body.to_s
  end
end
