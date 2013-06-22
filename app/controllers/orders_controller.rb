class OrdersController < ApplicationController
  before_filter :find_order, only: [:show]
  before_filter :create_order_guest_user, only: [:create]
  # before_filter :payment_lock_off, only: [:charge_or_refund, :charge_all]

  def show
    @member_profile = MemberProfile.new
  end

  def create
    @order = current_user.orders.new(params[:order])
    if CustomerOrder.new(@order, params[:stripeToken]).process_order
      redirect_to @order, notice: "Thanks! Please check your email."
    else
      redirect_to :back, flash: { error: "Did you fill in the email field and select a quantity?" }
    end
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
    redirect_to organizer_event_path(event)
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

  def payment_lock_off
    admins = @orders ? EventUser.where("event_id = ? AND state > 1", @orders.first.event.id) : nil
    if admins.nil?
      redirect_to :back, notice: "No Orders to Process"
    elsif admins.any? {|admin| admin.payment_lock }
      redirect_to :back, notice: "One or more Admins has locked payments"
    end
  end
end
