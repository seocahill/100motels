class OmniauthCallbacksController < ApplicationController

  def all
    auth = request.env["omniauth.auth"]
    event_id = current_user.events.first.id
    current_user.api_key = auth.credentials["token"]
    current_user.save!
    unless current_user.api_key.nil?
      redirect_to organizer_event_path(event_id), notice: "Connected to Stripe successfully"
    else
      redirect_to organizer_event_path(event_id), error: "Couldn't connect to Stripe"
    end
  end
  alias_method :stripe_connect, :all
end
