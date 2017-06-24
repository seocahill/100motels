require "test_helper"
include SharedBehaviour

class AdminEventShowTest < ActionDispatch::IntegrationTest

  before do
    @event = FactoryGirl.create(:event, :live_event, visible: false)
    @orders = FactoryGirl.create_list(:order, 5, event: @event)
    sign_in(@event.user)
    visit admin_event_path(@event)
  end

  test "admin can access event admin page" do
    assert page.has_content?(@event.name)
  end

  test "charge customers" do
    click_on "Charge Orders"
    assert page.has_css?('.alert', text: "Cool! We're charging your customers, we'll notify you when we're done")
  end

  test "cant charge customer is not connected to stripe" do
    @event.user.update_attributes(api_key: nil)
    click_on "Charge Orders"
    assert page.has_css?('.alert', text: "You need to connect to Stripe to make Charges")
  end

  test "admin can view order page for each order" do
    page.find('tbody>tr:last-child').click_link("view")
    assert page.has_content?("Order Receipt")
  end
end
