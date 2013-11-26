require "test_helper"
include SharedBehaviour

class NewMessageTest < Capybara::Rails::TestCase

  before do
    @event = FactoryGirl.create(:event, :live_event, visible: false)
    @orders = FactoryGirl.create_list(:order, 3, event: @event)
    sign_in(@event.user)
    click_link "Notify Customers"
  end

  test "ordinary message" do
    skip
  end

  test "defer message" do
    skip
  end

  test "cancel message" do
    skip
  end

  test "invalid message no body" do
    skip
  end

  test "invalid message no date" do
    skip
  end
end