require "test_helper"
include SharedBehaviour


class EventShowTest < Capybara::Rails::TestCase

  before do
    @event = FactoryGirl.create(:event, :live_event, date: "08-02-2014", id: 4)
  end

  test "poltergeist working" do
    skip
    Capybara.current_driver = Capybara.javascript_driver
    visit event_path(@event)
    page.save_screenshot('screenshot.png')
    assert_equal current_path, event_path(@event)
  end

  test "visible event by normal admin is visible" do
    visit event_path(@event)
    assert page.has_content?(@event.name), "event name not visible"
    assert page.has_content?(@event.location), "event location not visible"
    assert page.has_content?(@event.user.name), "owner name not visible"
    assert page.has_content?("February 08, 2014"), "event date not visible"
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
    assert page.has_content?(hidden_event.name)
    assert page.has_css?('button', text: 'Edit')
  end

  test "signed-in admin can edit event" do
    sign_in(@event.user)
    visit event_path(@event)
    assert page.has_css?('button', text: 'Edit')
  end

  test "signed-in admin can not edit an event they do not own" do
    sign_in(FactoryGirl.create(:user))
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
    fill_in "order[email]", with: "seo@example.com"
    select "2", from: "order[quantity]"
    assert page.find(".order-total").has_content?("21.11"), "order total incorrect"
    click_button "Purchase"
    sleep(5)
    fill_in "Card number", with: "4242424242424242"
    fill_in "Expires", with: "12/15"
    fill_in "Name on card", with: "Seo Cahill"
    fill_in "Card Code", with: "123"
    click_button "Checkout $21.11"
    assert page.has_css?('.alert', text: "Thanks! Please check your email.")
    assert_equal order_path(Order.last), current_path
  end

  test "order without email" do
    Capybara.current_driver = Capybara.javascript_driver
    visit event_path(@event)
    click_button "Purchase"
    fill_in "Card number:", with: "4242424242424242"
    fill_in "Expires:", with: "12/15"
    fill_in "Name on card:", with: "Seo Cahill"
    fill_in "Card Code:", with: "123"
    click_button "Checkout $10.71"
    assert page.has_css?('.alert', text: "must provide email address.")
  end

  test "order with invalid credit card details" do
    Capybara.current_driver = Capybara.javascript_driver
    visit event_path(@event)
    fill_in "order[email]", with: "seo@example.com"
    select "2", from: "order[quantity]"
    assert page.find(".order-total").has_content?("21.11"), "order total incorrect"
    click_button "Purchase"
    fill_in "Card number:", with: "4000000000000101"
    fill_in "Expires:", with: "12/15"
    fill_in "Name on card:", with: "Seo Cahill"
    fill_in "Card Code:", with: "123"
    click_button "Checkout $21.11"
    assert page.has_css?('.alert', text: "The card's security code is invalid.")
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
    click_on "Edit"
    find(:css, "textarea").set("New Text")
    click_on "Save"
    within ".event-media-html" do
      assert page.has_content?("New Text")
    end
  end

  test "edit button toggle with escape keypress" do
    Capybara.current_driver = Capybara.javascript_driver
    keypress_script = "var e = $.Event('keydown', { keyCode: '27' }); $('body').trigger(e);"
    sign_in(@event.user)
    visit event_path(@event)
    click_on "Edit"
    assert page.has_css?('.edit-about', text: "Save"), "expected Save"
    page.driver.execute_script(keypress_script)
    sleep 3
    # page.save_screenshot('screenshot.png')
    assert page.has_css?('.edit-about', text: "Edit"), "expected Edit"
  end
end