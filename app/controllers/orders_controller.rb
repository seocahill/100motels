class OrdersController < ApplicationController
  def new
    @cart = current_cart
    if @cart.line_items.empty?
      redirect_to(:back, :notice => 'Add something to your cart')
      return
    end
    @order = Order.new
  end

  def show
    @order = Order.find_by_id(params[:id])
  end

  def edit
  end

  def create
    @order = Order.new(params[:order])
    @order.add_line_items_from_cart(current_cart)
    if @order.save
      current_cart.destroy
      session[:cart_id] = nil
      redirect_to(@order, notice: "thanks, enjoy the show!")
    else
      render action: :new, notice: "Something went wrong"
    end    
  end

  def update  
  end
end