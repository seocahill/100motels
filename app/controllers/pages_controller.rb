class PagesController < ApplicationController

  #before_filter :authorize_admin!

  def home
    @cart = current_cart
    @events = Event.all(limit: 3)
    @users = User.all(order: :email, limit: 4)
  end
end
