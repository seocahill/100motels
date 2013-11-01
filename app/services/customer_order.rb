class CustomerOrder

  def initialize(order, token)
    @order = order
    @token = token
  end

  def process_order
    if @order.valid?
      add_customer_details_to_order
    end
    @order.save
  end

  def add_customer_details_to_order
    customer = create_customer
    if customer
      card = customer.cards.data
      @order.update_attributes(
          stripe_customer_token: customer.id,
          name: card[0].name,
          last4: card[0].last4,
          ticket_price: @order.event.ticket_price,
          total: total_inc_fees
        )
    else
      raise error
    end
  end

  def create_customer
    Stripe.api_key = ENV['STRIPE_API_KEY']
      customer = Stripe::Customer.create(
          email: @order.email,
          card: @token
      )
      customer
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error "Stripe error while creating customer: #{e.message}"
    return nil
  end

  def total_inc_fees
    (@order.quantity * (@order.event.ticket_price / 0.961) + 0.30).round(2)
  end

end