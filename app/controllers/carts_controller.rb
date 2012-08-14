class CartsController < ApplicationController
  
  def show
    @cart = Cart.find(params[:id])
  end

  def new
  end
  
  def create
  end
  
  def edit
  end

  def update
  end

  def destroy
    @cart = current_cart
    @cart.destroy
    session[:cart_id] = nil
    flash[:notice] = "Cart has been deleted"
    redirect_to root_path
  end
end
