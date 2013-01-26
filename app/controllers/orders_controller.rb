class OrdersController < ApplicationController
  before_filter :find_order, only: [:show]
  before_filter :find_orders, only: [:charge_or_refund]
  before_filter :create_order_guest_user, only: [:create]

  layout 'landing', only: [:show]

  def show
    @member_profile = MemberProfile.new
  end

  def create
    @order = current_user.orders.new(params[:order])
    customer = CustomerOrder.new(@order, params[:stripeToken])
    if customer.add_customer_to_order
      Notifier.delay.order_created(@order.id)
      redirect_to @order, notice: "Thanks! We sent you an email with a receipt for your order."
    else
      redirect_to :back, flash: { error: "Did you fill in the email field and select a quantity?" }
    end
  end

  def charge_or_refund
    if params[:charge]
      @orders.each { |order| ChargesWorker.perform_async(order.id) }
      flash[:notice] = "Processing #{@orders.count} orders, we'll email you when we're done."
    elsif params[:refund]
      @orders.each { |order| RefundCustomer.new(order, current_user).refund_charge if [:paid, :tickets_sent].include? order.stripe_event }
      Notifier.transaction_summary(@orders, current_user).deliver
      flash[:notice] = "Finished processing #{@orders.count} Customers, check your email for details."
    else
      flash[:error] = "Something went wrong."
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
    redirect_to organizer_root_path, notice: "Some records weren't found?"
  end

  def create_order_guest_user
    unless current_user
      user = User.create! { |u| u.profile = GuestProfile.create! }
      cookies[:auth_token] = user.auth_token
    end
  end
end
