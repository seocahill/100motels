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

  test "sign up from landing page" do
    click_link "Sign Up"
    fill_in "Name", with: "Seo"
    fill_in "Email", with: "seo@example.com"
    fill_in "Password", with: "foobar"
    click_button "Sign Up"
    assert page.has_css?('.alert', text: "Thanks for signing up! We've sent you an email to confirm your password")
    assert_equal user_path(User.last), current_path
  end

  test "sign in from landing page" do
    click_link "sign-in"
    fill_in "Email", with: @user.email
    fill_in "Password", with: @user.password
    click_button "Sign In"
    assert page.has_css?('.alert', text: "Logged in!")
  end

  test "click info links" do
    click_link "Info and Help"
    assert_equal info_path, current_path
  end

  test "click on terms and conditions" do
    click_link "Terms of Service"
    assert_equal info_path, current_path
  end

  test "go to all events" do
    click_link "events"
    assert_equal events_path, current_path
  end

  test "search for events" do
    FactoryGirl.create_pair(:event, user: @user, visible: true)
    fill_in "query", with: Event.first.name
    click_button "Go"
    assert_equal events_path, current_path, "wrong path"
    refute page.has_content?(Event.last.name), "search results returning wrong event"
    assert page.has_content?(Event.first.name), "search results missing query"
  end

  test "Try it free" do
    click_link "Try it free"
    assert_equal current_path, event_path(Event.last)
    assert page.has_css?('.alert', text: "Welcome Guest!")
    assert page.has_content?('Read this first!')
  end

  test "signed in root path" do
    sign_in(@user)
    assert_equal current_path, root_path
    assert page.has_css?('.alert', text: "Logged in!")
    assert page.has_content?('Settings')
    click_link "100 Motels"
    assert page.has_content?("Events Summary")
  end
end
