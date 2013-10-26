class ChargesWorker
  include Sidekiq::Worker

  def perform(order_id, api_key)
    order = Order.find(order_id)
    process_charge(order, api_key)
  end

  def process_charge(order, api_key)
    token = create_charge_token(order, api_key)
    charge = charge_customer(order, api_key, token)
    update_order(order, charge)
    order.save
  end

  def create_charge_token(order, api_key)
    token = Stripe::Token.create(
      { customer: order.stripe_customer_token },
      api_key
    )
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error "Stripe error while creating token: #{e.message}"
  end

  def charge_customer(order, api_key, token)
    charge = Stripe::Charge.create({
        amount: (order.total * 100).to_i,
        currency: "usd",
        card: token["id"],
        description: order.uuid,
        application_fee: 100
      }, api_key
    )
  rescue Stripe::CardError => e
    Rails.logger.error "Stripe error while creating customer: #{e.message}"
  end

  def process_charge(order, charge)
    if charge.present?
      order.stripe_charge_id = charge[:id]
      order.stripe_event = charge[:paid] == true ? :charged : :failed
    else
      order.stripe_event = :failed
    end
  end
end