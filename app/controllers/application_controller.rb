class ApplicationController < ActionController::Base
  protect_from_forgery

  private

    def current_user
      @current_user ||= User.find_by_auth_token(cookies[:auth_token]) if cookies[:auth_token]
    end
    helper_method :current_user

    def signed_in?
      redirect_to login_url, alert: "Please Sign in." if current_user.nil? || current_user.state_suspended?
    end

    def authorized?
      if current_user
        @event.user == current_user
      else
        redirect_to root_url, alert: "Not Authorized"
      end
    end
end