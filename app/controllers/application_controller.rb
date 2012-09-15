class ApplicationController < ActionController::Base
  protect_from_forgery

  # if Rails.env.production?
  #   http_basic_authenticate_with :name => "zappa", :password => "phase 2?"
  # end

  private

    def authorize_admin!
      authenticate_user!
      unless current_user.admin?
        flash[:alert] = "You must be an admin to do that."
        redirect_to root_path
      end
    end

    def current_cart
      Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end
end