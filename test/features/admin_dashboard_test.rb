require "test_helper"
include SharedBehaviour

class AdminDashboardTest < Capybara::Rails::TestCase

  before do
    @event = FactoryGirl.create(:event, :live_event, visible: false)
    @orders = FactoryGirl.create_list(:order, 5, event: @event)
    sign_in(@event.user)
  end

  test "admin can access event admin page" do
    assert page.has_content?('Top Selling Shows')
  end

  test "navigation to event" do
    within "#aqua" do
      click_link @event.name
      assert_equal event_path(@event), current_path
    end
  end

  test "admin can view order page for each order" do
    skip "it works"
    click_link "#{Order.first.id.truncate(length: 10)}"
    assert page.has_content?("Order Receipt")
  end
end