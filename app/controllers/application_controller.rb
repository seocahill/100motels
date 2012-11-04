class ApplicationController < ActionController::Base
  protect_from_forgery

  # todo after signin path for devise

  private

    def authorize_admin!
      authenticate_user!
      unless current_user.has_role? :god || :promoter
        flash[:alert] = "You can't do that"
        redirect_to root_path
      end
    end

    def calculate_location
      current_location = request.location.city
      if user_signed_in? && current_user.location.city
        current_user.location.city
      elsif !current_location.empty?
        current_location
      else
        "Burnaby"
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