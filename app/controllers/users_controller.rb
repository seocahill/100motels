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

  # def update
  #   @user.update_attributes(params[:user])
  #   respond_to do |format|
  #     if @user.update_attributes(params[:user])
  #       format.html { redirect_to(@user, :notice => 'User was successfully updated.') }
  #       format.json { respond_with_bip(@user) }
  #     else
  #       format.html { render :action => "edit" }
  #       format.json { respond_with_bip(@user) }
  #     end
  #   end
  # end
end
