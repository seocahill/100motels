class OrdersController < ApplicationController
  before_filter :find_order, only: [:show]
  before_filter :find_orders, only: [:charge_or_refund]

  def show
  end

  def create
    @order = current_user.orders.new(params[:order])
    customer = CustomerOrder.new(@order, params[:stripeToken])
    if customer.add_customer_to_order
      Notifier.order_processed(@order).deliver
      redirect_to @order, notice: "Thanks! We sent you an email with a receipt for your order."
    else
      redirect_to :back, flash: { error: "Did you fill in the email field and select a quantity?" }
    end
  end

  def charge_or_refund
    @organizer = current_user
    if params[:charge]
      @orders.each { |order| ChargeCustomer.new(order, @organizer).process_charge if [:pending, :failed].include? order.stripe_event }
      @orders.each { |order| order.quantity.times {order.tickets.create(event_id: order.event_id)} if order.stripe_event == :paid }
      Notifier.transaction_summary(@orders, @organizer).deliver
      flash[:notice] = "Finished processing #{@orders.count} Customers, check your email for details."
    elsif params[:refund]
      @orders.each { |order| RefundCustomer.new(order, @organizer).refund_charge if [:paid, :tickets_sent].include? order.stripe_event }
      Notifier.transaction_summary(@orders, @organizer).deliver
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
end
