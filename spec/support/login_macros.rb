module LoginMacros

  def signed_in(user)
    click_link 'sign-in'
    fill_in 'Email', with: user.profile.email
    fill_in 'Password', with: user.profile.password
    click_button 'Sign In'
    visit root_path
  end

end