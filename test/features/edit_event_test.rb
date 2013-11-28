require "test_helper"
include SharedBehaviour

class EditEventTest < Capybara::Rails::TestCase

  before do
    user = FactoryGirl.create(:user, state: :unconfirmed)
    @event = FactoryGirl.create(:event, visible: false, user: user)
    sign_in(@event.user)
    page.find('tbody>tr:last-child').click_link("edit")
  end

  test "change Event Target" do
    fill_in "Target", with: 105
    click_button "Submit"
    assert page.has_css?('.alert', text: "Event has been updated"), "event wasn't updated"
    @event.reload
    assert_equal @event.target, 105, "target not updated"
  end

  test "change event date should fail if orders" do
    FactoryGirl.create(:order, event: @event)
    fill_in "Date", with: "12-05-2525"
    click_button "Submit"
    assert page.has_css?('.alert', text: "can't change the date of an event with existing orders, send a deferral message instead."), "didn't show validation errors."
  end

  test "change event location should fail if orders" do
    FactoryGirl.create(:order, event: @event)
    fill_in "Location", with: "New England"
    click_button "Submit"
    assert page.has_css?('.alert', text: "can't change the location of an event with existing orders, create a new event or cancel the orders."), "didn't show validation errors."
  end

  test "change event date should fail if user unconfirmed" do
    check "Visible"
    click_button "Submit"
    assert page.has_css?('.alert', text: "sign up to publish events"), "didn't show validation errors."
  end

end