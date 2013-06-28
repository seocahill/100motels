class OmniauthCallbacksController < ApplicationController

  def all
    current_user.connect(request) if current_user.state_beta?
    if current_user.api_key.present?
      redirect_to root_path, notice: "Connected to Stripe successfully"
    else
      redirect_to root_path
      flash[:error] = "Contact support to be added to beta user list"
    end
  end
  alias_method :stripe_connect, :all
end
