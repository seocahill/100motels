require "test_helper"
include SharedBehaviour

class EventShowTest < ActionDispatch::IntegrationTest

  before do
    @event = FactoryGirl.create(:event, :live_event, date: "08-02-2014", id: 4)
  end

  test "visible event by normal admin is visible" do
    visit event_path(@event)
    assert page.has_content?(@event.location), "event location not visible"
    assert page.has_content?("Saturday, Feb 8"), "event date not visible"
  end

  test "invisible event is invisible" do
    hidden_event = FactoryGirl.create(:event, visible: false)
    visit event_path(hidden_event)
    assert_equal current_path, root_path, "user wasn't redirected away from hidden_event"
  end

  test "signed in admin can view invisible event if they own it" do
    hidden_event = FactoryGirl.create(:event, visible: false)
    sign_in(hidden_event.user)
    visit event_path(hidden_event)
    sleep(1)
    assert_selector('#showEditor')
  end

  test "signed-in admin can edit event" do
    sign_in(@event.user)
    visit event_path(@event)
    sleep(1)
    assert_selector('#showEditor')
  end

  test "signed-in admin can not edit an event they do not own" do
    other_event = FactoryGirl.create(:event)
    sign_in(other_event.user)
    visit event_path(@event)
    sleep(1)
    assert_no_selector('#showEditor')
  end

  test "suspended user event not public" do
    suspended = FactoryGirl.create(:user, state: :suspended)
    event = FactoryGirl.create(:event, visible: true, user: suspended)
    visit event_path(event)
    assert_equal current_path, root_path, "should be redirected to root as admin is guest or suspended"
  end

  test "placing an order successfully" do
    use_js_driver
    visit event_path(@event)

    select "2", from: "order[quantity]"
    assert first(".order-total").has_content?("21.11"), "order total incorrect"
    click_button "Purchase"
    sleep(2)
    assert_equal current_path, event_path(@event), "should be on event page"
    print page.html
    stripe_iframe = all('iframe[name=stripe_checkout_app]').last
    within_frame(stripe_iframe) do
      fill_in "Email", with: "ocathais@example.com"
      fill_in "Card number", with: "4242424242424242"
      fill_in "Expiry", with: "12/#{Time.now.year + 1}"
      fill_in "CVC", with: "123"
      click_button "Checkout"
    end
    sleep(7)
    assert page.has_css?('.alert', text: "Thanks! Please check your email."), "no success message"
  end

  test "order pages can be reviewed by event admin only" do
    order = FactoryGirl.create(:order)
    visit order_path(order)
    assert_equal current_path, root_path, "shouldn't allow viewing of order"
  end

  test "as admin click edit for inline editing and save" do
    use_js_driver
    sign_in(@event.user)
    visit event_path(@event)
    sleep(2)
    assert_equal current_path, event_path(@event), "should be on event page"
    find(:css, "#showEditor").click
    find(:css, "textarea").set("New Text")
    click_on "Save"
    within ".about-box" do
      assert page.has_content?("New Text")
    end
  end
end
