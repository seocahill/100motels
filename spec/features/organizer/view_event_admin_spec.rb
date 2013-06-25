require 'spec_helper'

feature "Event Options" do

  background do
    @event = create(:event, :visible)
    @event.orders << create(:order)
    ApplicationController.any_instance.stub(current_user: @event.users.first.decorate)
    visit organizer_events_path
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

end
