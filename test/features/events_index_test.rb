require "test_helper"
include SharedBehaviour

class EventsIndexTest < Capybara::Rails::TestCase

  before do
    FactoryGirl.create_pair(:event, :live_event)
    visit events_path
  end

  test "visible events are visible" do
    assert page.has_content?(Event.last.name), "event name not visilbe"
    assert page.has_content?(Event.last.location), "event location not visilbe"
    assert page.has_content?(Event.last.date.strftime('%d/%m')), "event date not visilbe"
    assert page.has_content?(Event.first.name), "other event not visible"
  end

  test "reset shows all" do
    fill_in "query", with: "keine results"
    refute page.has_content?(Event.last.name)
    click_button "Reset"
    assert page.has_content?(Event.last.name)
  end

  test "successful query" do
    fill_in "query", with: Event.first.name
    click_button "Search"
    refute page.has_content?(Event.last.name), "search results returning wrong event"
    assert page.has_content?(Event.first.name), "search results missing query"
  end

  test "go to event page" do
    click_link Event.first.location
    assert_equal event_path(Event.first), current_path
  end
end