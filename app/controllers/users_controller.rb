class UsersController < ApplicationController

  before_filter :find_user, :only => [:show, :edit, :update, :destroy]

  def index
    @users = User.all(order: "email")
  end
  
  private

    def find_user
      @user = User.find(params[:id])
    end
end
