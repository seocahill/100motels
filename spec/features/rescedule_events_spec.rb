require 'spec_helper'

feature 'Reschedule Event' do

  background do
    @event = create(:event)
    ApplicationController.any_instance.stub(current_user: @event.event_users.first.user.decorate)
    @event.orders << create(:order)
    visit organizer_event_path(@event)
    save_and_open_page
  end

  scenario 'it should work' do
    expect(page).to have_content(@event.title)
  end

end