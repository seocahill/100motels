class PagesController < ApplicationController

  #before_filter :authorize_admin!

  def home
    @events = Event.all
    @users = User.all
    @cart = current_cart
  end
end
