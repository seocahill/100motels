class UsersController < ApplicationController

  before_filter :find_user, :only => [:show, :edit, :update, :destroy, :change_card]

  def index
    @users = User.all(order: "email")
  end

  def show
    @orders = Order.where(:email => current_user.email).page(params[:page]).per_page(3)
  end

  def change_card
    card = params[:stripeToken]
    if @user.save_card(@user, card)
      redirect_to(root_path, notice: "Card updated successfully")
    else
      redirect_to(@user, notice: "Something went wrong")
    end
  end

  private

    def find_user
      @user = User.find(params[:id])
    end
end
