require "test_helper"
include SharedBehaviour

class TicketTest < Capybara::Rails::TestCase

  before do
    @event = FactoryGirl.create(:event, :live_event, visible: false)
    @orders = FactoryGirl.create_list(:order, 3, event: @event)
    sign_in(@event.user)
    click_link "Ticket Checking"
  end

  test "number doesn't exist" do
    skip
  end

  test "number already admitted" do
    skip
  end

  test "number checked, admit holder" do
    skip
  end
end