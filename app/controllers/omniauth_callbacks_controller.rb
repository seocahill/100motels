class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def all
    auth = request.env["omniauth.auth"]
    current_user.api_key = auth.credentials["token"]
    current_user.save!
    unless current_user.api_key.nil?
      flash.notice = "Connected to Stripe successfully"
      redirect_to organizer_root_path
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end
  alias_method :stripe_connect, :all

end
