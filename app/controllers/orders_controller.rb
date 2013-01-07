class OrdersController < ApplicationController

  before_filter :find_order, only: [:show]

  def new
    @order = Order.new
  end

  def show
    @order = Order.find_by_id(params[:id])
    @event = Event.find_by_id(@order.event_id)
    @guest = guest_user
  end

  def edit
  end

  def create
    @order = current_or_guest_user.orders.new(params[:order])
    if current_user && current_user.customer_id
      @order.customer_order
      Notifier.order_processed(@order).deliver
      redirect_to :back, notice: "Thanks! Please check your email for your receipt."
    elsif @order.save_customer(params[:stripeToken])
      Notifier.order_processed(@order).deliver
      redirect_to :back, notice: "Thanks! Please check your email for your receipt."
    else
      redirect_to :back, flash: { error: "Sorry something went wrong. Did you fill in all the fields?" }
    end
  end

  def update
  end

  def charge_multiple
    orders = Order.find(params[:order_ids])
    organizer = Profile.find(params[:organizer])
    refund = params[:refund]
    if orders && organizer && !refund
      orders.each { |order| order.charge_customer(organizer)}
      # orders.each { |order| Notifier.ticket(order).deliver }
      redirect_to(:back, notice: "Charge successful")
    elsif orders && organizer && refund
      orders.each { |order| order.refund_customer(organizer) }
      orders.each { |order| Notifier.ticket(order).deliver }
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
    # authenticate_user!
    @order = current_or_guest_user.orders.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

end
