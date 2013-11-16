class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:signin][:email])
    if user
      params[:signin][:remember_me] ? cookies.permanent[:auth_token] = user.auth_token : cookies[:auth_token] = user.auth_token
      redirect_to root_path, notice: "Logged in!"
    else
      flash.now.alert = "Email or password is invalid."
      render :new
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to root_url
  end
end
