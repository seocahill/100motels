require "test_helper"
include SharedBehaviour

class AdminEventShowTest < Capybara::Rails::TestCase

  before do
    @event = FactoryGirl.create(:event, :live_event, visible: false)
    @orders = FactoryGirl.create_list(:order, 5, event: @event)
    sign_in(@event.user)
    page.find('tbody>tr:last-child').click_link("admin")
  end

  test "admin can access event admin page" do
    assert_equal admin_event_path(@event), current_path
  end

  test "navigation to other administered event" do
    other_event = FactoryGirl.create(:event, user: @event.user)
    click_link "#{@event.name} in #{@event.location}"
    click_link "#{other_event.name} in #{other_event.location}"
    assert_equal admin_event_path(other_event), current_path
  end

  test "notify customers of event changes" do
    click_link "Notify Customers"
    assert_equal new_admin_event_message_path(@event), current_path
    assert page.has_content?("Send Notification")
  end

  test "charge customers" do
    click_button "Charge Customers"
    assert page.has_css?('.alert', text: "Cool! We're charging your customers, we'll notify you when we're done")
  end

  test "ticket checking" do
    click_link "Ticket Checking"
    assert_equal current_path, admin_event_tickets_path(@event)
  end

  test "Search returns correct results" do
    fill_in "query", with: Order.first.name
    click_on "Search"
    assert page.has_content?(Order.first.email)
    refute page.has_content?(Order.last.name)
  end

  test "admin can view order page for each order" do
    page.find('tbody>tr:last-child').click_link("view")
    assert page.has_content?("Order Receipt")
  end
end