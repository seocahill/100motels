require "test_helper"
include SharedBehaviour

class PagesIndexTest < Capybara::Rails::TestCase

  before do
    @user = FactoryGirl.create(:user)
    visit root_path
  end

  test "landing on home" do
    assert_content page, "100 Motels"
    refute_content page, "Atlantic Records"
  end

  test "sign in from landing page" do
    click_link "sign-in"
    fill_in "signin[email]", with: @user.email
    fill_in "signin[password]", with: @user.password
    click_button "Sign in"
    assert page.has_css?('.alert', text: "Logged in!")
  end

  test "click info links" do
    click_link "info"
    assert_equal info_path, current_path
  end

  test "click on terms and conditions" do
    click_link "legal"
    assert_equal info_path, current_path
  end

  test "go to all events" do
    click_link "events"
    assert_equal events_path, current_path
  end

  test "Try it Free" do
    click_link "Try it Free"
    assert_equal current_path, event_path(Event.last)
    assert page.has_css?('.alert', text: "Welcome Guest!")
    assert page.has_content?('Read this first!')
  end

  test "signed in root path" do
    sign_in(@user)
    assert_equal current_path, root_path
    assert page.has_css?('.alert', text: "Logged in!")
    assert page.has_content?('Activity')
    click_link "100 Motels"
    assert page.has_content?("Orders")
  end

end
