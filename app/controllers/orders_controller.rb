class OrdersController < ApplicationController

  # layout 'stripe', only: [:new, :create]

  def new
    @order = Order.new
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

  def charge_multiple
    orders = Order.find(params[:order_ids])
    promoter = User.find(params[:promoter])
    if orders && promoter
      @orders.each do { |order| order.charge_customer(order, promoter)}
      redirect_to(:back, notice: "You got your money!")
    else
      redirect_to(:back, notice: "Charge failed")
    end
  end

  def refund_multiple

  end
end
