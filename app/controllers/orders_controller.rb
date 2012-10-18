class OrdersController < ApplicationController

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
    if @order.save_customer(stripe_token)
      Notifier.order_processed(@order).deliver
      redirect_to(@order, notice: "Processed successfully")
    else
      redirect_to(:back, notice: "failed validations")
    end
  end

  def update
  end

  def charge_multiple
    orders = Order.find(params[:order_ids])
    promoter = User.find(params[:promoter])
    refund = params[:refund]
    if orders && promoter && !refund
      orders.each { |order| order.charge_customer(order, promoter)}
      # orders.each { |order| Notifier.order_charged(order).deliver }
      redirect_to(:back, notice: "Charge successful")
    elsif orders && promoter && refund
      orders.each { |order| order.refund_customer(order, promoter)}
      # orders.each { |order| Notifier.order_refunded(order).deliver }
      redirect_to(:back, notice: "Refund successful")
    else
      redirect_to(:back, notice: "Something went wrong")
    end
  end
end
