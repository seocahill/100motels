require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  def setup
    @user = FactoryGirl.create(:user, password_reset_token: "nVEi-279A3uD6CFRU2c-Kg")
  end

  test "password_reset" do
    email = UserMailer.password_reset(@user.id).deliver
    assert !ActionMailer::Base.deliveries.empty?

    # Test the body of the sent email contains what we expect it to
    assert_equal ['noreply@100motels.com'], email.from
    assert_equal [@user.email], email.to
    assert_equal 'Password Reset', email.subject
    assert_match "http://www.example.com/password_resets/nVEi-279A3uD6CFRU2c-Kg/edit", email.body.to_s
  end
end