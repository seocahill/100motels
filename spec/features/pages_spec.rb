require 'spec_helper'

feature 'Authentication' do

  background do
    visit root_path
    @member = create :member_user
  end

  scenario 'Sign In' do
    click_link 'sign-in'
    fill_in 'Email', with: 'foo@bar.com'
    fill_in 'Password', with: "secret"
    click_button 'Sign In'
    expect(page).to have_content("Logged in!")
  end

  scenario 'Signed In' do
    signed_in(@member)
    first(:link, 'View Events').click
    expect(current_path).to eq events_path
    expect(page).to have_content(@member.profile.email)
  end

end
