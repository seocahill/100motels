require "test_helper"
include SharedBehaviour

class EventsIndexTest < Capybara::Rails::TestCase

  before do
    FactoryGirl.create_pair(:event, :live_event)
    visit events_path
  end

  test "visible events are visible" do
    assert page.has_content?(Event.last.name), "second event not visilbe"
    assert page.has_content?(Event.first.name), "first event not visible"
  end

end