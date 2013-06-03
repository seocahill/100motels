require 'spec_helper'

feature 'Authentication' do

  background do
    visit root_path
  end

  scenario 'Sign Up and Sign Out' do
    click_link 'Sign Up'
    fill_in 'Email', with: 'foo@bar.com'
    fill_in 'Password', with: "secret"
    click_button 'Sign up'
    expect(page).to have_content("Thanks nearly there! We've sent you a link to confirm your email address.")
    click_link 'foo@bar.com'
    click_link 'Sign out'
    expect(page).to have_content('sign-in')
  end

  scenario 'Save Account' do
    first(:link, 'Try it free').click
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

  scenario 'Sign In' do
    user = create(:member_user)
    click_link 'sign-in'
    fill_in 'Email', with: user.profile.email
    fill_in 'Password', with: "secret"
    click_button 'Sign In'
    expect(page).to have_content("Logged in!")
  end

  scenario 'Confirm User' do
    user = create(:member_user)
    signed_in(user.profile)
    click_link user.profile.email
    click_link "Confirm your email"
    expect(user.profile).to eq MemberProfile.last
    last_email.to.should include(user.profile.email)
    last_email.body.encoded.should match(confirm_email_confirmation_url(MemberProfile.last.email_confirm_token))
    visit confirm_email_confirmation_url(MemberProfile.last.email_confirm_token)
    expect(page).to have_content("Email has been confirmed.")
  end

  scenario 'Change User Email', js: true do
    user = create(:member_user)
    signed_in(user.profile)
    click_link user.profile.email
    click_link 'Your Account'
    # sleep 5
    # bip_text MemberProfile.last, :email, "new@foobar.com"
    # save_screenshot('tmp/screengrabs/grab.png')
    # # click_button "Done"
    expect(page).to have_content "User Profile"
  end

  scenario 'Delete Account' #do
  #   user = create(:member_user)
  #   signed_in(user.profile)
  #   click_link user.profile.email
  #   click_link 'Your Account'
  #   click_link 'Delete Account'
  #   expect(User.count).to change_by(-1)
  #   expect(MemberProfile.count).to change_by(-1)
  # end

end
