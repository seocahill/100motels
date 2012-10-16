class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    user = User.from_omniauth(request.env["omniauth.auth"], current_user)
    if !user.uid.nil?
      flash.notice = "Connected to Stripe successfully"
      redirect_to(:back)
      # sign_in_and_redirect user
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end
  alias_method :stripe_connect, :all
end
