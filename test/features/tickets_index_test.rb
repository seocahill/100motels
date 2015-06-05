require "test_helper"
include SharedBehaviour

class TicketsIndexTest < Capybara::Rails::TestCase

  before do
    @event = FactoryGirl.create(:event, :live_event, visible: false)
    @orders = FactoryGirl.create_list(:order, 3, event: @event)
    @other_ticket = FactoryGirl.create(:ticket)
    sign_in(@event.user)
  end

  test "number doesnt exist" do
    click_link "Tickets"
    skip "for whatever reason react isnt play well with capybara here"
  end
end
