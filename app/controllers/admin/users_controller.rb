class Admin::UsersController < Admin::BaseController
  def index
    @users = User.all(:order => "email")
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user].except(:admin))
    #set_admin
    if @user.save
      flash[:notice] = "User has been created."
      redirect_to admin_users_path
    else
      flash[:alert] = "User has not been created."
      render :action => "new"
    end
  end
  
  def show

  end
  
  def edit
    
  end
  
  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
    end
    set_admin
    if @user.update_attributes(params[:user])
      flash[:notice] = "User has been updated."
      redirect_to admin_users_path
    else
      flash[:alert] = "User has not been updated."
      render :action => "edit"
    end
  end
end
