require 'spec_helper'

feature "Event Admin Actions" do

  background do
    @event = create(:event, :visible)
    @event.orders << create(:order)
    ApplicationController.any_instance.stub(current_user: @event.users.first.decorate)
    visit admin_events_path
  end

  scenario "naviage to Dash" do
    expect(page).to have_content "Dashboard"
  end

  scenario "send group message to customers" do
    click_link "Promote"
    fill_in "message[subject]", with: "Event Update"
    fill_in "message[content]", with: "Going Good Everyone"
    click_button "Send Group Email"
    expect(page).to have_content "Message sent!"
    last_email.to.should include(@event.orders.first.email)
  end

  scenario "delay event" do
    click_link "Event"
    # find("input.datepicker[type=text]").click
    # page.execute_script %Q{ $('a.ui-datepicker-next').trigger("click") }
    # page.execute_script %Q{ $("a.ui-state-default:contains('15')").trigger("click")}
    fill_in "alter_event[date]", with: "31-12-2015"
    fill_in "alter_event[message]", with: "Hello World"
    click_button "Defer"
    expect(page).to have_content "Your Event will be Deferred"
    last_email.body.encoded.should match(cancel_order_url(@event.orders.first.uuid))
  end
end
