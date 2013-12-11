class ChargesWorker
  include Sidekiq::Worker

  def perform(order_id, api_key)
    @order = Order.find(order_id)
    @api_key = api_key
    process_charge
    @order.save!
    @order
  end

  def process_charge
    charge = charge_customer
    if charge.present?
      @order.stripe_charge_id = charge[:id]
      @order.stripe_event = charge[:paid] == true ? :charged : :failed
    else
      @order.stripe_event = :failed
    end
  end

  def charge_customer
    token = create_charge_token
    charge = Stripe::Charge.create({
        amount: (@order.total * 100).to_i,
        currency: "usd",
        card: token["id"],
        description: @order.id,
        application_fee: 100
      }, @api_key
    )
  rescue Stripe::CardError => e
    Rails.logger.error "Stripe error while creating customer: #{e.message}"
    return nil
  end

  def create_charge_token
    token = Stripe::Token.create(
      { customer: @order.stripe_customer_token },
      @api_key
    )
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error "Stripe error while creating token: #{e.message}"
    return nil
  end
end