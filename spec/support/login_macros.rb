module LoginMacros

  def signed_in(profile)
    click_link 'sign-in'
    fill_in 'Email', with: profile.email
    fill_in 'Password', with: profile.password
    click_button 'Sign In'
    visit root_path
  end

  def guest_session
    visit root_path
    first(:link, 'Try it free').click
  end

end