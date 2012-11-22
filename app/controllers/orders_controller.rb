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
    if current_user && current_user.customer_id
      @order.customer_order
      Notifier.order_processed(@order).deliver
      redirect_to(@order, notice: "Processed successfully")
    elsif @order.save_customer(params[:stripeToken])
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
    promoter = Profile.find(params[:promoter])
    refund = params[:refund]
    if orders && promoter && !refund
      orders.each { |order| order.charge_customer(promoter)}
      # orders.each { |order| Notifier.order_charged(order).deliver }
      redirect_to(:back, notice: "Charge successful")
    elsif orders && promoter && refund
      orders.each { |order| order.refund_customer(promoter) }
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
    authenticate_user!
    @order = current_user.orders.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

end
