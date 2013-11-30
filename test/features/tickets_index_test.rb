require "test_helper"
include SharedBehaviour

class TicketsIndexTest < Capybara::Rails::TestCase

  before do
    @event = FactoryGirl.create(:event, :live_event, visible: false)
    @orders = FactoryGirl.create_list(:order, 3, event: @event)
    @other_ticket = FactoryGirl.create(:ticket)
    sign_in(@event.user)
    visit admin_event_tickets_path(@event)
  end

  test "number doesnt exist" do
    fill_in "number", with: @other_ticket.number
    click_on "Check"
    assert page.has_css?(".alert", text: "Ticket not found"), "should display not found"
  end

  test "number already admitted" do
    @event.tickets.first.update_attributes(admitted: "Nov 30, 1:45 AM")
    fill_in "number", with: @event.tickets.first.number
    click_on "Check"
    assert page.has_css?(".alert", text: "already admitted at Nov 30, 1:45 AM")
  end

  test "number checked admit holder" do
    fill_in "number", with: @event.tickets.last.number
    click_on "Check"
    assert page.has_css?(".alert", text: "Admit ticket-holder")
  end
end