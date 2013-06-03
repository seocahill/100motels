module LoginMacros

  def signed_in(user)
    click_link 'sign-in'
    fill_in 'Email', with: user.profile.email
    fill_in 'Password', with: user.profile.password
    click_button 'Sign In'
    visit root_path
  end

  def guest_session
    visit root_path
    first(:link, 'Try it free').click
  end

end