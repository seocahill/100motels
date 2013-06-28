require 'spec_helper'

feature 'Reschedule Event' do
  subject(:event) { create(:event) }
  background do
    ApplicationController.any_instance.stub(current_user: event.event_users.first.user.decorate)
    event.orders << create(:order)
    visit organizer_event_path(event)
  end

  scenario 'I can access the admin panel' do
    expect(page).to have_content event.title
  end

  scenario 'Defer Event to a later date' do
    click_link 'Event Options'
    click_link 'Defer Event'
    within '#defer-event' do
      select '2014', from: 'event_date_1i'
      select 'January', from: 'event_date_2i'
      select '31', from: 'event_date_3i'
      fill_in "reason", with: "Drummer Died"
      click_button "Confirm Deferral"
    end
    expect(page).to_not have_content "Your Event was Deferred"
    last_email.to.should include(event.orders.first.email)
  end
end