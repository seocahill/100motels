require 'spec_helper'

feature "Event Options" do

  background do
    @event = create(:event, :visible)
    ApplicationController.any_instance.stub(current_user: @event.users.first)
    ApplicationController.any_instance.stub(authorize_admin: true)
  end

  scenario "unlock payments for event" do
    visit organizer_event_path(@event)
    expect(page).to have_content {truncate(@event.title, length: 10)}
    expect(page).to have_content @event.title
  end
end
