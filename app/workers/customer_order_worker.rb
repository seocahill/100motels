class CustomerOrderWorker
  include Sidekiq::Worker

  # sidekiq_options retry: false

  def perform(order_id, token)
    order = Order.find(order_id)
    token = token
    update_order_with_customer_details(order, token)
  end

  def update_order_with_customer_details(order, token)
    customer = get_customer_object(order, token)
      order.update_attributes(
        stripe_customer_token: customer.id,
        name: customer.active_card["name"],
        last4: customer.active_card["last4"]
      )
  end

  def get_customer_object(order, token)
    user = User.find(order.user_id)
    user.customer_id ? retrieve_customer(user) : create_customer(order, token)
  end

  def retrieve_customer(user)
    Stripe.api_key = ENV['STRIPE_API_KEY']
    customer = Stripe::Customer.retrieve(user.customer_id)
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error "Stripe error while retrieving customer: #{e.message}"
  end

  def create_customer(order, token)
    Stripe.api_key = ENV['STRIPE_API_KEY']
      customer = Stripe::Customer.create(
          email: order.email,
          card: token
      )
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error "Stripe error while creating customer: #{e.message}"
  end
end