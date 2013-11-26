require "test_helper"
include SharedBehaviour

class PasswordResetTest < Capybara::Rails::TestCase

  before do
    @user = FactoryGirl.create(:user, password_reset_token: "resetme", password_reset_sent_at: Time.now)
    visit login_path
    click_link "forgot password?"
  end

  test "password reset sends email" do
    fill_in :email, with: @user.email
    click_button "Reset Password"
    assert page.has_css?(".alert", text: "Email sent with password reset instructions.")
  end

  test "password with valid email resets" do
    skip
  end

  test "password with invalid email doesn't reset" do
    skip
  end

  test "expired token resends new token" do
    skip
  end
end