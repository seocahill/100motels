require "test_helper"
include SharedBehaviour

class NewMessageTest < Capybara::Rails::TestCase

  before do
    @event = FactoryGirl.create(:event, :live_event, visible: false)
    @orders = FactoryGirl.create_list(:order, 3, event: @event)
    sign_in(@event.user)
    visit new_admin_event_message_path(@event)
  end

  test "defer message" do
    fill_in "Optional message to customers", with: "My Message"
    fill_in "New date if rescheduling", with: "31-12-2015"
    click_on "Reschedule"
    assert page.has_css?(".alert", text: "Event has been deferred"), "message not sent"
  end

  test "cancel message" do
    fill_in "Optional message to customers", with: "My Message"
    click_on "Cancel Event"
    assert page.has_css?(".alert", text: "Event has been cancelled"), "message not sent"
  end

  test "invalid cancel no body" do
    click_on "Cancel Event"
    assert page.has_css?(".alert", text: "Message can't be blank"), "message not sent"
  end

  test "invalid deferral no date" do
    fill_in "Optional message to customers", with: "My Message"
    click_on "Reschedule"
    assert page.has_css?(".alert", text: "Date can't be blank"), "message not sent"
  end
end
