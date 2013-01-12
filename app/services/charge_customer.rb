class ChargeCustomer

  def initialize(order, organizer)
    @order = order
    @organizer = organizer
  end

  def create_charge_token
    Stripe.api_key = @organizer.api_key
    token = Stripe::Token.create(
      { customer: @order.stripe_customer_token },
      key
    )
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error "Stripe error while creating token: #{e.message}"
  end

  def charge_customer(&:create_charge_token)
    total = (@order.total * 100).to_i
    fee = total.round
    token = yield
    Stripe.api_key = @organizer.api_key
    charge = Stripe::Charge.create(
      {
        amount: order_amount,
        currency: "usd",
        card: token["id"],
        description: "testing 3rd party charges",
        application_fee: fee
      }, key
    )
  rescue Stripe::CardError => e
    Rails.logger.error "Stripe error while creating customer: #{e.message}"
  end
end