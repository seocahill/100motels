class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    user = User.from_omniauth(request.env["omniauth.auth"], current_user)
    if !user.profile.api_key.nil?
      flash.notice = "Connected to Stripe successfully"
      redirect_to promoter_root_path
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end
  alias_method :stripe_connect, :all
end
