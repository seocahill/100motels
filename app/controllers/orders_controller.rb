class OrdersController < ApplicationController

  layout 'stripe'

  def new
    @cart = current_cart
    if @cart.line_items.empty?
      redirect_to(:back, :notice => 'Add something to your cart first')
      return
    end
    @order = Order.new
    @promoter = @order.get_promoter(current_cart)
  end

  def show
    @order = Order.find_by_id(params[:id])
  end

  def edit
  end

  def create
    @order = Order.new(params[:order])
    @order.add_line_items_from_cart(current_cart)
    if @order.save_customer(@promoter)
      current_cart.destroy
      session[:cart_id] = nil
      redirect_to(@order, notice: "Processed successfully")
      Notifier.order_processed(@order).deliver
    else
      render action: :new, notice: "Something went wrong"
    end
  end

  def update
  end
end
