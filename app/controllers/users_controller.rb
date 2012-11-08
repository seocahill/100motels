class UsersController < ApplicationController

  def index
    @users = User.all(order: "email")
  end

  def show
    @user = User.find(params[:id])
    @orders = Order.where(:email => current_user.email).page(params[:page]).per_page(3)
  end

  def change_card
    @user = User.find(params[:id])
    card = params[:stripeToken]
    if @user.save_card(@user, card)
      redirect_to(@user, notice: "Card updated successfully")
    else
      redirect_to(@user, notice: "Something went wrong")
    end
  end
end
