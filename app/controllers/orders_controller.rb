class OrdersController < ApplicationController
  before_filter :find_order, only: [:show]
  # before_filter :create_order_guest_user, only: [:create]
  before_filter :check_ownership, except: [:new, :create]

  def show
    @member_profile = MemberProfile.new
  end

  def create
    @order = Order.new(params[:order])
    if CustomerOrder.new(@order, params[:stripeToken]).process_order
      session[:current_order_id] = @order.id.to_s
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
    @order = Order.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    redirect_to root_path
  end

  def create_order_guest_user
    unless current_user
      user = User.create! { |u| u.profile = GuestProfile.create! }
      cookies[:auth_token] = user.auth_token
    end
  end

  def check_ownership
    redirect_to root_path unless params[:id] == session[:current_order_id]
  end
end
