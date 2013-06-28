class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        if params[:remember_me]
        cookies.permanent[:auth_token] = @user.auth_token
      else
        cookies[:auth_token] = @user.auth_token
      end
        flash[:notice] = 'Thank you for signing up!.'
        format.html { redirect_to(@user) }
      else
        format.html { render action: "new" }
      end
    end
  end

  def stripe_disconnect
    current_user.api_key = nil
    current_user.save!
    redirect_to root_path, notice: "Stipe API key reset"
  end
end
