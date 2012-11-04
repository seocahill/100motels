class OrdersController < ApplicationController

  before_filter :find_order, only: [:show]

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
    if params[:stripeToken]
      stripe_token = params[:stripeToken]
      if @order.save_customer(stripe_token, current_user)
        Notifier.order_processed(@order).deliver
        redirect_to(@order, notice: "Processed successfully")
      end
    elsif current_user.customer_id
      if @order.customer_order(current_user)
        Notifier.order_processed(@order).deliver
        redirect_to(@order, notice: "Processed successfully")
      end
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

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    flash[:notice] = "Your order was cancelled"
    redirect_to :back
  end

private

  def find_order
    @order = Order.find(params[:id]).where()
    rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

end
