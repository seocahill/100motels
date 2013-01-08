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
    if customer.add_customer_to_order?
      Notifier.order_processed(order).deliver
      redirect_to :back, notice: "Thanks! We sent you an email with a receipt for your order."
    else
      redirect_to :back, flash: { error: "Sorry something went wrong. Did you fill in all the fields?" }
    end
  end

  def charge_orders
    charges = ChargeCustomers.new(@orders)
    if charges.charged?
      orders.each { |order| order.charge_customer(organizer)}
      orders.each { |order| Notifier.ticket(order).deliver }
      redirect_to(:back, notice: "Charge successful")
    else
      redirect_to(:back, notice: "Something went wrong")
    end
  end

  def refund_orders
    RefundCustomers.new(@orders)
    if valid?
      orders.each { |order| order.refund_customer(organizer) }
      orders.each { |order| Notifier.ticket(order).deliver }
      redirect_to(:back, notice: "Refund successful")
    else
      redirect_to(:back, notice: "Something went wrong")
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
