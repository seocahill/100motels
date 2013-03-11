Doorkeeper.configure do
  resource_owner_authenticator do |routes|
    User.find_by_auth_token(cookies[:auth_token]) || redirect_to(routes.login_url(return_to: request.fullpath))
  end
  admin_authenticator do |routes|
    user = User.find_by_auth_token(cookies[:auth_token])
    if user.present?
      user.state_god? || redirect_to(routes.root_path)
    end
  end
end
