class SessionsController < ApplicationController

  def new
  end

  def create
    auth = Authentication.new(params)
    # if user status is normal or admin
    if auth.authenticated?
      if params[:signin][:remember_me]
        cookies.permanent[:auth_token] = auth.user.auth_token
      else
        cookies[:auth_token] = auth.user.auth_token
      end
      session[:current_order_id] = nil
      redirect_to root_path, notice: "Logged in!"
    else
      flash.now.alert = "Email or password is invalid."
      render :new
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to root_url, notice: "Logged out!"
  end
end
