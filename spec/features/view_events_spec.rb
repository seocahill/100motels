require 'spec_helper'

feature 'View Events' do

  background do
    @event = create :event, :visible, date: (3).months.from_now
    visit events_path
  end

  scenario 'list published Events only' do
    hidden = create :event
    expect(page).to have_content(@event.artist)
    expect(page).to have_content(@event.title)
    expect(page).to have_content(@event.date.strftime('%d/%m/%Y'))
    expect(page).to have_content(@event.location.city)
    expect(page).to_not have_content(hidden.artist)
  end

  scenario 'Search for an Event' do
    new_event = create :event, :visible
    fill_in 'query', with: new_event.venue
    click_button 'Go'
    expect(current_path).to eq events_path
    expect(page).to have_content new_event.artist
    expect(page).to_not have_content @event.venue
  end

  scenario 'Filter Events on tonight' do
    tonight = create :event, :visible, date: (Time.now.end_of_day - 1.hour)
    click_link 'Filter by Date'
    click_link 'Today'
    expect(page).to have_content(tonight.artist)
    expect(page).to_not have_content(@event.artist)
  end

  scenario 'Filter Events on this week' do
    this_week = create :event, :visible, date: (Time.now.end_of_week - 1.hour)
    click_link 'Filter by Date'
    click_link 'This Week'
    expect(page).to have_content(this_week.artist)
    expect(page).to_not have_content(@event.artist)
  end

  scenario 'Filter Events on this month' do
    this_month = create :event, :visible, date: (Time.now.end_of_month - 1.hour)
    click_link 'Filter by Date'
    click_link 'This Month'
    expect(page).to have_content(this_month.artist)
    expect(page).to_not have_content(@event.artist)
  end

  scenario 'Browse to individual event page' do
    first('.thumbnail').click
    expect(current_path).to eq event_path(@event)
  end
end
