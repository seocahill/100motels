class OrdersController < ApplicationController

  # layout 'stripe', only: [:new, :create]

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
    @event = Event.find_by_id(@order.event_id)
  end

  def edit
  end

  def create
    @order = Order.new(params[:order])
    stripe_token = params[:stripeToken]
    event = Event.find_by_id(params[:order][:event_id])
    promoter = User.find_by_id(event.promoter_id)
    if @order.save_customer(promoter, stripe_token)
      redirect_to(@order, notice: "Processed successfully")
      # Notifier.order_processed(@order).deliver
    else
      redirect_to(event, notice: "failed validations")
    end
  end

  def update
  end
end
