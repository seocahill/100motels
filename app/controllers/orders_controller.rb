class OrdersController < ApplicationController
  before_filter :find_order, only: [:show]
  before_filter :check_ownership, except: [:new, :create, :cancel]

  def show
  end

  def create
    event = Event.find(order_params[:event_id])
    @order = event.orders.build(order_params)
    if CustomerOrder.new(@order, params[:stripeToken]).process_order
      session[:current_order_id] = @order.id.to_s
      redirect_to @order, notice: "Thanks! Please check your email."
    else
      redirect_to :back, flash: { error: "Did you fill in the email field?" }
    end
  end

  def charge_all
    event = Event.find(params[:event_id])
    @orders = event.orders.where("stripe_event = 0 OR stripe_event = 3")
    if @orders.length > 0 and current_user.api_key.present?
      ChargeCustomer.new(@orders).process_charges
      flash[:notice] = "Processing #{@orders.count} orders, we'll email you when we're done."
    else
      flash[:error] = "Can't charge unless there are valid orders and admin is connected to Stripe Account"
    end
    redirect_to organizer_event_path(event)
  end

  def cancel
    order = Order.find_by_uuid(params[:id])
    order.cancel_order
    if order.stripe_event_cancelled?
      redirect_to root_path, notice: "Your order has been cancelled"
    else
      redirect_to root_path, notice: "This order can't be cancelled, please contact support"
    end
  end

  def destroy
    order = Order.find(params[:id])
    order.state = :cancelled
    redirect_to root_path, notice: "Your Order has been Cancelled"
    session[:current_order_id] = nil
  end

private
  def find_order
    @order = Order.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def order_params
    params.require(:order).permit(:email, :quantity, :event_id)
  end

  def check_ownership
    redirect_to root_path unless params[:id] == session[:current_order_id]
  end
end