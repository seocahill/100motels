class PagesController < ApplicationController

  #before_filter :authorize_admin!

  def home
    @cart = current_cart
    @events = Event.all(limit: 4)
    @users = User.all(limit: 4) 
  end
end
