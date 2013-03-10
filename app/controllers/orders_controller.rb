class OrdersController < ApplicationController
  before_filter :find_order, only: [:show]
  before_filter :find_orders, only: [:charge_or_refund]
  before_filter :create_order_guest_user, only: [:create]


  def show
    @member_profile = MemberProfile.new
  end

  def create
    @order = current_user.orders.new(params[:order])
    if CustomerOrder.new(@order, params[:stripeToken]).process_order
      Notifier.delay.order_created(@order.id)
      Notifier.delay.notify_admin_order_created(@order.id)
      redirect_to @order, notice: "Thanks! Please check your email."
    else
      redirect_to :back, flash: { error: "Did you fill in the email field and select a quantity?" }
    end
  end

  def charge_or_refund
    if params[:charge]
      ChargeCustomer.new(@orders).process_charges
      flash[:notice] = "Processing orders."
    elsif params[:refund]
      RefundCustomer.new(@orders).refund_charge
      flash[:notice] = "Refunding orders."
    elsif params[:cancel]
      CancelEventOrders.new(@orders).cancel_orders
      flash[:notice] = "Cancelling orders."
    else
      flash[:error] = "Something went wrong."
    end
    redirect_to :back
  end

  def charge_all
    event = Event.find(params[:event_id])
    @orders = event.orders.where("stripe_event = 0 OR stripe_event = 3")
    if @orders.length > 0
      ChargeCustomer.new(@orders).process_charges
      flash[:notice] = "Processing #{@orders.count} orders, we'll email you when we're done."
    else
      flash[:error] = "Couldn't Charge All."
    end
    redirect_to :back
  end

private
  def find_order
    @order = current_user.orders.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def find_orders
    @orders = Order.find(params[:order_ids])
    rescue ActiveRecord::RecordNotFound
    redirect_to :back, notice: "Some records weren't found"
  end

  def create_order_guest_user
    unless current_user
      user = User.create! { |u| u.profile = GuestProfile.create! }
      cookies[:auth_token] = user.auth_token
    end
  end
end
