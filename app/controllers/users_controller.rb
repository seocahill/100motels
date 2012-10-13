class UsersController < ApplicationController

  before_filter :find_user, :only => [:show, :edit, :update, :destroy]

  def index
    @users = User.all(order: "email")
  end

  def show
    @events = Event.where(@user.id == :promoter_id)
  end

  private

    def find_user
      @user = User.find(params[:id])
    end
end
