class Customer
  def initialize(order, token = nil)
    @order = order
    @token = token
    @user = User.find(@order.user_id)
  end

  def add_customer_to_order
    customer = @user.customer_id ? retrieve_customer : create_customer
    @order.stripe_customer_token = customer.id
    @order.name = customer.active_card["name"]
    @order.last4 = customer.active_card["last4"]
    @order.save!
  end

  def create_customer
    Stripe.api_key = ENV['STRIPE_API_KEY']
      customer = Stripe::Customer.create(
          email: @order.email,
          card: @token
      )
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while creating customer: #{e.message}"
  end

  def retrieve_customer
    Stripe.api_key = ENV['STRIPE_API_KEY']
    customer = Stripe::Customer.retrieve(@user.customer_id)
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while retrieving customer: #{e.message}"
  end
end