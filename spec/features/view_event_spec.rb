require 'spec_helper'

feature 'Event#show' do

  background do
    @event = create :event, :visible
    visit event_path(@event)
  end

  context 'signed out' do
    scenario 'it should display the event\'s\' public details' do
      pending
    end
  end
end