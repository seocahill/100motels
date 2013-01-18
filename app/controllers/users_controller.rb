class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @orders = Order.all
  end

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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    @user.save!
  end

  def change_card
    @user = User.find(params[:id])
    card = params[:stripeToken]
    if UpdateCard.new(@user, card).update_user_record
      redirect_to(@user, notice: "Card updated successfully")
    else
      redirect_to(@user, notice: "Something went wrong")
    end
  end
end
