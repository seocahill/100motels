require 'spec_helper'

feature "Event Options" do

  background do
    @event = create(:event, :visible)
    ApplicationController.any_instance.stub(current_user: @event.users.first.decorate)
  end

  scenario "unlock payments for event" do
    visit organizer_event_path(@event)
    expect(page).to have_content {truncate(@event.title, length: 10)}
  end
end
