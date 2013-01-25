class OrdersController < ApplicationController
  before_filter :find_order, only: [:show]
  before_filter :create_order_guest_user, only: [:create]

  layout 'landing', only: [:show]

  def show
    @member_profile = MemberProfile.new
  end

  def create
    @order = current_user.orders.new(params[:order])
    customer = CustomerOrder.new(@order, params[:stripeToken])
    if customer.add_customer_to_order
      CustomerOrderWorker.perform_async(@order.id)
      redirect_to @order, notice: "Thanks! We sent you an email with a receipt for your order."
    else
      redirect_to :back, flash: { error: "Did you fill in the email field and select a quantity?" }
    end
  end

  def charge_or_refund
    order_ids = params[:order_ids]
    user_id = current_user.id
    if params[:charge]
      order_ids.each { |order_id| ProcessOrdersWorker.perform_async(order_id, user_id) }
      # Notifier.transaction_summary(@orders, current_user.email).deliver
      flash[:notice] = "Processing #{@orders.count} orders, this could take a while. We'll email you when we're done."
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

  def create_order_guest_user
    unless current_user
      user = User.create! { |u| u.profile = GuestProfile.create! }
      cookies[:auth_token] = user.auth_token
    end
  end
end
