require 'spec_helper'

feature '#Index' do

  background do
    visit root_path
    @member = create :member_user
    @event = create :event, :visible
    # signed_in(@member)
    # save_screenshot('tmp/screengrabs/grab.png')
  end

  scenario 'Navigate to Events and back via logo' do
    click_link 'events'
    expect(page).to have_content(@event.artist)
    click_link '100 Motels'
    expect(page).to have_content("Tour the world without a record label")
  end

  scenario 'Try it Free' do
    first(:link, 'Try it free').click
    expect(current_path).to eq event_path(Event.last)
    expect(page).to have_content "Welcome to your event, you can save this account at any time, click on 'save account' in the top menu"
    expect(page).to have_content "save your account"
  end

  scenario 'Search for Event' do
    new_event = create :event, :visible
    fill_in 'query', with: new_event.venue
    click_button 'Go'
    expect(current_path).to eq events_path
    expect(page).to have_content new_event.artist
    expect(page).to_not have_content @event.venue
  end

  scenario 'Find out More' do
    first(:link, 'More').click
    expect(current_path).to eq info_path
  end

  scenario 'How it Works' do
    click_link 'how it works'
    expect(current_path).to eq info_path
  end

end
