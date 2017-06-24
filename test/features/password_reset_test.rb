require "test_helper"
include SharedBehaviour

class PasswordResetTest < ActionDispatch::IntegrationTest

  before do
    @user = FactoryGirl.create(:user, password_reset_token: "resetme", password_reset_sent_at: Time.now)
  end

  test "password reset sends email" do
    visit login_path
    click_link "forgotten password?"
    fill_in "email", with: @user.email
    click_button "Reset Password"
    assert page.has_css?(".alert", text: "Email sent with password reset instructions.")
  end

  test "password with valid email resets" do
    visit edit_password_reset_path(@user.password_reset_token)
    fill_in "Password", with: "newpassword"
    click_on "Change Password"
    assert page.has_css?(".alert", text: "Password has been reset."), "password reset didn't work"
  end

  test "password with invalid email doesn't reset" do
    visit login_path
    click_link "forgotten password?"
    fill_in "email", with: @user.email
    click_button "Reset Password"
    assert page.has_css?(".alert", text: "Email sent with password reset instructions.")
  end

  test "expired token resends new token" do
    @other_user = FactoryGirl.create(:user, password_reset_token: "resetmeother", password_reset_sent_at: 4.hours.ago)
    visit edit_password_reset_path(@other_user.password_reset_token)
    fill_in "Password", with: "newpassword"
    click_on "Change Password"
    assert page.has_css?(".alert", text: "Password reset has expired."), "wasn't expired properly"
  end
end
