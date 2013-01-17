class ApplicationController < ActionController::Base
  protect_from_forgery


  private

    def authorize_admin!
      # authenticate_user!
    end

    def user_signed_in?
      # not working yet
    end

    def current_or_guest_user
      # does nothing yet
    end
end