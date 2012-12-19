class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :current_or_guest_user

  # todo after signin path for devise
  # if user is logged in, return current_user, else return guest_user
  def current_or_guest_user
    if current_user
      if session[:guest_user_id]
        session[:guest_user_id] = nil
      end
      if current_user.guest_id
        guest_orders
      end
      current_user
    else
      guest_user
    end
  end

  # find guest_user object associated with the current session,
  # creating one as needed
  def guest_user
    User.find(session[:guest_user_id] ||= create_guest_user.id)
  end

  private

    def authorize_admin!
      authenticate_user!
      unless current_user.has_role? :organizer
        flash[:alert] = "You can't do that"
        redirect_to root_path
      end
    end

    def calculate_location
        "Burnaby"
    end

    # called (once) when the user logs in, insert any code your application needs
    # to hand off from guest_user to current_user.
    def guest_orders
      guest_orders = User.find(current_user.guest_id).orders.all
      guest_orders.each do |order|
        order.user_id = current_user.id
        order.save
      end
      current_user.guest_id = nil
      current_user.save
    end

    def create_guest_user
      u = User.create(:email => "guest_#{Time.now.to_i}#{rand(99)}@example.com")
      u.save(:validate => false)
      u
    end

end