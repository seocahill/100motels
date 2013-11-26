require "test_helper"
include SharedBehaviour

class NewEventTest < Capybara::Rails::TestCase

  before do
    @user = FactoryGirl.create(:user)
    sign_in(@user)
    click_link "New Event"
  end

  test "successful Event creation" do
    fill_in "Name", with: "New Thing"
    fill_in "Location", with: "Ballina, Ireland"
    fill_in "Date", with: "31-12-2014"
    fill_in "Target", with: 100
    fill_in "Ticket price", with: 10.0
    check "Visible"
    click_button "Create New Event"
    assert_equal current_path, event_path(Event.last)
    assert page.has_css?('.alert', text: "Event was successfully created"), "event wasn't created"
  end

  test "invalid Event creation" do
    click_button "Create New Event"
    assert page.has_css?('.alert', text: "Must have location, must have date, must have target, must have ticket price."), "didn't show validation errors."
  end

end