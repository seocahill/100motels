class CustomerOrder

  def initialize(order, token)
    @order = order
    @token = token
    @error = nil
  end

  def process_order
    add_customer_details_to_order || @error
  end

  def add_customer_details_to_order
    customer = create_customer
    card = customer.cards.data
    @order.update_attributes(
        stripe_customer_token: customer.id,
        name: card[0].name,
        last4: card[0].last4,
        ticket_price: @order.event.ticket_price,
        total: total_inc_fees
      )
  end

  def create_customer
    Stripe.api_key = ENV['STRIPE_API_KEY']
      customer = Stripe::Customer.create(
          email: @order.email,
          card: @token
      )
      customer
  rescue Stripe::CardError => e
    body = e.json_body
    @error  = body[:error][:message]
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error "Stripe error while creating customer: #{e.message}"
    @error = "Order couldn't be processed, please contact support"
  end

  def total_inc_fees
    # TODO: case usd, gbp, eur, cad, aud etc
    handling_fee = 0.04
    stripe_pro_rata_fee = 0.029
    stripe_standing_charge = 0.3
    net_total = @order.quantity * (@order.event.ticket_price)
    gross_total = (net_total + stripe_standing_charge) / (1 - handling_fee - stripe_pro_rata_fee)
    gross_total.round(2)
  end

end