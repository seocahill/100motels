class OmniauthCallbacksController < ApplicationController
  before_action :signed_in?

  def all
    current_user.connect(request)
    if current_user.api_key.present? and current_user.stripe_uid.present?
      redirect_to root_path, notice: "Connected to Stripe successfully"
    else
      redirect_to root_path
      flash[:error] = "Contact support"
    end
  end
  alias_method :stripe_connect, :all
end
