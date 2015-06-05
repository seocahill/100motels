require "test_helper"
include SharedBehaviour

class EventsIndexTest < Capybara::Rails::TestCase

  before do
    FactoryGirl.create_pair(:event, :live_event)
    visit events_path
  end

  test "visible events are visible" do
    assert page.has_content?(Event.first.name[0..11]+"..."), "event name not visible"
    assert page.has_content?(Event.last.location), "event location not visible"
    assert page.has_content?(Event.last.date.strftime('%d/%m')), "event date not visible"
    assert page.has_content?(Event.first.location), "other event not visible"
  end

  test "successful query" do
    fill_in "query", with: Event.first.location
    click_button "Search"
    refute page.has_content?(Event.last.location), "search results returning wrong event"
    assert page.has_content?(Event.first.location), "search results missing query"
  end

  test "go to event page" do
    click_link Event.first.location
    assert_equal event_path(Event.first), current_path
  end
end
