class PagesController < ApplicationController

  #before_filter :authorize_admin!

  def home
    @cart = current_cart
    @events = Event.all
    @users = User.all
    
  end
end
