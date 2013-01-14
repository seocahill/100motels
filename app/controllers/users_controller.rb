class UsersController < ApplicationController

  def index
    @users = User.all(order: "email")
  end

  def show
    @user = User.find(params[:id])
    @orders = current_user.orders.page(params[:page]).per_page(3)
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
