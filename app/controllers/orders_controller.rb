class OrdersController < ApplicationController
  before_action :check_ownership, only: :show

  def show
    @order = Order.find(params[:id])
  end

  def create
    event = Event.find(order_params[:event_id])
    @order = event.orders.build(order_params)
    processed_order = CustomerOrder.new(@order, params).process_order if @order.valid?
    if processed_order == true
      OrderMailer.order_created(@order.id).delay
      session[:current_order_id] = @order.id.to_s
      redirect_to @order, notice: "Thanks! Please check your email."
    else
      redirect_to :back, flash: { error: processed_order || "must provide email address"}
    end
  end

  def cancel
    order = Order.find(params[:id])
    if order.stripe_event_charged?
      redirect_to event_path(order.event), notice: "Orders can't be cancelled after they've been charged. Please contact the event organizer or support to obtain a refund."
    else
      order.stripe_event = :cancelled
      order.save
      redirect_to event_path(order.event), notice: "Your order has been cancelled"
    end
  end

  def destroy
    order = Order.find(params[:id])
    order.state = :cancelled
    redirect_to root_path, notice: "Your Order has been Cancelled"
    session[:current_order_id] = nil
  end

private
  def order_params
    params.require(:order).permit(:email, :quantity, :event_id)
  end

  def check_ownership
    redirect_to root_path unless params[:id] == session[:current_order_id] or Order.find(params[:id]).event.user == current_user
  end
end