class UsersController < ApplicationController

  before_filter :find_user, :only => [:show, :edit, :update, :destroy]

  def index
    @users = User.all(order: "email")
  end

  def show
    @orders = Order.where(:email => current_user.email).page(params[:page]).per_page(5)
  end

  def media_preview
    render text: current_user.media_html
  end

  private

    def find_user
      @user = User.find(params[:id])
    end
end
