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

  scenario 'Save Account' do
    guest_session
    click_link 'save your account'
    click_link 'Save Account'
    fill_in 'Email', with: 'bar@foo.com'
    fill_in 'Password', with: "secret"
    click_button 'Sign up'
    expect(page).to have_content("Thanks nearly there! We've sent you a link to confirm your email address.")
    last_email.to.should include('bar@foo.com')
    last_email.body.encoded.should match(confirm_email_confirmation_url(MemberProfile.last.email_confirm_token))
    visit confirm_email_confirmation_url(MemberProfile.last.email_confirm_token)
    expect(page).to have_content("Email has been confirmed.")
  end
end
