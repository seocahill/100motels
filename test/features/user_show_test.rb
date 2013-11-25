require "test_helper"
include SharedBehaviour

class UserShowTest < Capybara::Rails::TestCase

  before do
    @user = FactoryGirl.create(:user)
    FactoryGirl.create_pair(:event, :live_event, user: @user)
    sign_in(@user)
  end

  test "update name" do
    fill_in "Name", with: "Joebob"
    click_button "Update Account"
    assert page.has_css?('.alert', text: "You must enter your password to confirm changes.")
    fill_in "Current password", with: @user.password
    click_button "Update Account"
    assert page.has_css?('.alert', text: "Settings updated")
  end

  test "update email" do
    fill_in "Email", with: "unconfirmed@example.confirm"
    fill_in "Current password", with: @user.password
    click_button "Update Account"
    assert page.has_css?('.alert', text: "We've sent you an email to confirm your password")
  end

  test "connect to stripe" do
    click_link "Connect with Stripe"
    assert page.has_css?('a.btn btn-success', text: "Connected to Stripe")
    assert page.has_css?('.alert', text: "Connected to Stripe successfully")
  end

  test "reset password" do
    click_link "Reset Password"
    assert page.has_css?('.alert', text: "Email sent with password reset instructions.")
  end

  test "new event" do
    click_link "New Event"
    assert page.has_content?("New Event")
    assert_equal current_path, new_admin_event_path, "did not go to new event form"
  end

  test "edit event from Events Summary" do
    page.find('tbody>tr:last-child').click_link("edit")
    assert page.has_content?("Edit Event")
  end

  test "go to event admin from Events Summary row" do
    page.find('tbody>tr:last-child').click_link("admin")
    assert page.has_css?('.btn-info', text: "Notify Customers")
  end
end