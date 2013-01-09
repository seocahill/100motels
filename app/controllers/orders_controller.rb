class OrdersController < ApplicationController
  before_filter :find_order, only: [:show]
  before_filter :find_orders, only: [:charge_orders, :refund_orders]

  def new
    @order = Order.new
  end

  def show
  end

  def create
    order = current_or_guest_user.orders.new(params[:order])
    customer = Customer.new(order, params[:stripeToken])
    if customer.add_customer_to_order
      Notifier.order_processed(order).deliver
      redirect_to :back, notice: "Thanks! We sent you an email with a receipt for your order."
    else
      redirect_to :back, flash: { error: "Did you fill in the email field and select a quantity?" }
    end
  end

  def charge_or_refund
    if params[:name] == "charge"
      orders.each do |order|
        charge = ChargeCustomer.new(order, current_user)
        if charge.processed?
          # email and ticket
        else
          # fail email no ticket
        end
      end
      redirect_to(:back, notice: "Processing in the background")
    elsif params[:name] == "refund"
      orders.each { |order| RefundCustomer.new(order, current_user)}
      redirect_to(:back, notice: "Processing in the background")
    else
      redirect_to :back, flash: { error: "Something went wrong" }
    end
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
    redirect_to :back, notice: "some records weren't found?"
  end
end
