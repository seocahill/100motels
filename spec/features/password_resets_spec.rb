require 'spec_helper'

feature "Password Reset" do

  scenario "emails user when requesting password reset" do
    user = create(:member_user)
    visit login_path
    click_link "forgotten password?"
    fill_in "Email", :with => user.profile.email
    click_button "Reset Password"
    current_path.should eq(events_path)
    page.should have_content("Email sent with password reset instructions.")
    last_email.to.should include(user.profile.email)
  end

  scenario "does not email invalid user when requesting password reset" do
    visit login_path
    click_link "forgotten password?"
    fill_in "Email", :with => "nobody@example.com"
    click_button "Reset Password"
    current_path.should eq(events_path)
    page.should have_content("Email sent with password reset instructions.")
    last_email.should be_nil
  end

  scenario "updates the user password when confirmation matches" do
    user = create(:member_user)
    user.profile.password_reset_token = "something"
    user.profile.password_reset_sent_at = 1.hour.ago
    user.profile.save
    visit edit_password_reset_path(user.profile.password_reset_token)
    fill_in "Password", :with => "foobar"
    click_button "Update Password"
    page.should have_content("Password has been reset")
  end

  scenario "reports when password token has expired" do
    user = create(:member_user)
    user.profile.password_reset_token = "something"
    user.profile.password_reset_sent_at = 5.hours.ago
    user.profile.save
    visit edit_password_reset_path(user.profile.password_reset_token)
    fill_in "Password", :with => "foobar"
    click_button "Update Password"
    page.should have_content("Password reset has expired")
  end

  scenario "raises record not found when password token is invalid" do
    visit edit_password_reset_path("invalid")
    expect(current_path).to eq root_path
  end
end
