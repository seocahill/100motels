class OrdersController < ApplicationController
  before_filter :find_order, only: [:show]
  before_filter :find_orders, only: [:charge_or_refund]

  def new
    @order = Order.new
  end

  def show
  end

  def create
    @order = current_or_guest_user.orders.new(params[:order])
    customer = CustomerOrder.new(@order, params[:stripeToken])
    if customer.add_customer_to_order
      Notifier.order_processed(@order).deliver
      redirect_to @order
      flash[:notice] = "Thanks! We sent you an email with a receipt for your order."
    else
      redirect_to :back, flash: { error: "Did you fill in the email field and select a quantity?" }
    end
  end

  def charge_or_refund
    @organizer = Profile.find(current_user.profile)
    if params[:charge]
      @orders.each { |order| ChargeCustomer.new(order, @organizer) if order.stripe_event == :pending }
      flash[:notice] = "Successfully charged #{@orders.count} Customers."
    elsif params[:refund]
      @orders.each { |order| RefundCustomer.new(order, @organizer).refund_charge if order.stripe_event == :paid }
      flash[:notice] = "Successfully refunded #{@orders.count} Customers."
    else
      flash[:error] = "Something went wrong."
    end
    redirect_to :back
  end

private

  def find_order
    @order = current_or_guest_user.orders.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def find_orders
    @orders = Order.find(params[:order_ids])
    rescue ActiveRecord::RecordNotFound
    redirect_to organizer_root_path, notice: "Some records weren't found?"
  end
end
