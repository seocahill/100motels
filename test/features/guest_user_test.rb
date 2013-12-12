require "test_helper"
include SharedBehaviour

class GuestUserTest < Capybara::Rails::TestCase

  before do
    visit root_path
    click_link "Try it Free"
  end

  test "Save Account" do
    click_link "Save your Account"
    fill_in "Name", with: "show"
    fill_in "Email", with: "show@example.com"
    fill_in "Password", with: "foodbar"
    click_on "Sign Up"
    assert page.has_css?(".alert", text: "Thanks for signing up! We've sent you an email to confirm your password"), "didnt' work"
  end

end