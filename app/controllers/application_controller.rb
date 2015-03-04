class ApplicationController < ActionController::Base
  protect_from_forgery

  def json_for(target, options = {})
    options[:scope] ||= self
    options[:url_options] ||= url_options
    target.active_model_serializer.new(target, options).to_json
  end
  helper_method :json_for

  private

    def current_user
      @current_user ||= User.find_by_auth_token(cookies[:auth_token])
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
