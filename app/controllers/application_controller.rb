class ApplicationController < ActionController::Base
  protect_from_forgery

  private

    def current_user
      user = User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
      @current_user ||= user unless user.state_suspended?
    end
    helper_method :current_user

    def signed_in?
      redirect_to login_url, alert: "Please Sign in." if current_user.nil? || current_user.state_suspended?
    end

    def authorized?(event_id)
      unless Event.find(event_id).user == current_user
        redirect_to root_url, alert: "Not Authorized"
      end
    end
end