require "test_helper"
include SharedBehaviour

class EventShowTest < Capybara::Rails::TestCase

  before do
    @event = FactoryGirl.create(:event, :live_event, date: "08-02-2014", id: 4)
  end

  test "visible event by normal admin is visible" do
    visit event_path(@event)
    assert page.has_content?(@event.location), "event location not visible"
    assert page.has_content?("Saturday, Feb 8"), "event date not visible"
    assert page.has_content?(@event.about), "about html not visible"
  end

  test "invisible event is invisible" do
    hidden_event = FactoryGirl.create(:event, visible: false)
    visit event_path(hidden_event)
    assert page.has_css?(".alert", text: "The event you were looking for could not be found")
    assert_equal current_path, events_path, "user wasn't redirected away from hidden_event"
  end

  test "signed in admin can view invisible event if they own it" do
    hidden_event = FactoryGirl.create(:event, visible: false)
    sign_in(hidden_event.user)
    visit event_path(hidden_event)
    assert page.has_css?('button', text: 'Edit')
  end

  test "signed-in admin can edit event" do
    sign_in(@event.user)
    visit event_path(@event)
    assert page.has_css?('button', text: 'Edit')
  end

  test "signed-in admin can not edit an event they do not own" do
    other_event = FactoryGirl.create(:event)
    sign_in(other_event.user)
    visit event_path(@event)
    refute page.has_css?('button', text: 'Edit')
  end

  test "suspended user event not public" do
    suspended = FactoryGirl.create(:user, state: :suspended)
    event = FactoryGirl.create(:event, visible: true, user: suspended)
    visit event_path(event)
    assert_equal current_path, events_path, "should be redirected to root as admin is guest or suspended"
  end

  test "placing an order successfully" do
    Capybara.current_driver = Capybara.javascript_driver
    visit event_path(@event)
    select "2", from: "order[quantity]"
    assert page.find(".order-total").has_content?("21.11"), "order total incorrect"
    click_button "Purchase"
    within_frame(page.find('.stripe_checkout_app')[:name]) do
      fill_in "email", with: "ocathais@example.com"
      fill_in "card_number", with: "4242424242424242"
      fill_in "cc-exp", with: "12/15"
      fill_in "cc-csc", with: "123"
      click_button "Checkout $21.11"
    end
    page.save_screenshot('screengrab.png')
    sleep 5
    assert page.has_css?('.alert', text: "Thanks! Please check your email."), "no success message"
    assert_equal order_path(Order.last), current_path, "didn't redirect to order page"
  end

  test "order pages can be reviewed by event admin only" do
    order = FactoryGirl.create(:order)
    visit order_path(order)
    assert_equal current_path, root_path, "shouldn't allow viewing of order"
  end

  test "as admin click edit for inline editing and save" do
    Capybara.current_driver = Capybara.javascript_driver
    sign_in(@event.user)
    visit event_path(@event)
    click_button "Edit"
    find(:css, "textarea").set("New Text")
    click_on "Save"
    within ".event-media-html" do
      assert page.has_content?("New Text")
    end
  end

  test "edit button toggle" do
    Capybara.current_driver = Capybara.javascript_driver
    sign_in(@event.user)
    visit event_path(@event)
    click_on "Edit"
    assert page.has_css?('.edit-about', text: "Save"), "expected Save"
    click_on "Save"
    assert page.has_css?('.edit-about', text: "Edit"), "expected Edit"
  end

  test "escape key edit toggle" do
    Capybara.current_driver = Capybara.javascript_driver
    sign_in(@event.user)
    visit event_path(@event)
    click_on "Edit"
    assert page.has_css?('.edit-about', text: "Save"), "expected Save"
    native.send_key(:Escape)
    assert page.has_css?('.edit-about', text: "Edit"), "expected Edit"
  end
end