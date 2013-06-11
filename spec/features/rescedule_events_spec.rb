require 'spec_helper'

feature 'Reschedule Event' do

  background do
    @event = create(:event)
    ApplicationController.any_instance.stub(current_user: @event.event_users.first.user.decorate)
    @event.orders << create(:order)
    visit organizer_event_path(@event)
  end

  scenario 'reschedule event to later date' do
    click_link "Reschedule Event"
    fill_in "New Date", with: "31-12-2014"
    click_button "submit"
    expect(page).to have_content "Event has been Rescheduled"
  end

end