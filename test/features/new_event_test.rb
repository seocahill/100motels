require "test_helper"
include SharedBehaviour

class NewEventTest < Capybara::Rails::TestCase

  before do
    @user = FactoryGirl.create(:user)
    FactoryGirl.create(:event, user: @user)
    sign_in(@user)
    click_link "New Event"
  end

  test "successful event creation" do
    fill_in "event[name]", with: "New Thing"
    fill_in "event[location]", with: "Ballina, Ireland"
    fill_in "event[date]", with: "31-12-2014"
    fill_in "event[time]", with: Time.now
    fill_in "event[target]", with: 100
    fill_in "event[ticket_price]", with: 10.0
    check "event[visible]"
    click_button "Submit"
    assert_equal current_path, event_path(Event.last), "incorrect path"
    assert page.has_css?('.alert', text: "Event was successfully created"), "event wasn't created"
  end

end
