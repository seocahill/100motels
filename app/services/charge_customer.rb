class ChargeCustomer

  def initialize(order, organizer)
    @order = order
    @key = organizer.api_key
  end

  def process_charge
    charge = charge_customer
    unless charge.nil?
      @order.stripe_charge_id = charge[:id]
      charge[:paid] == true ? @order.stripe_event = :paid : @order.stripe_event = :failed
    else
      @order.stripe_event = :failed
      Notifier.charge_failed(@order).deliver
    end
    @order.save!
  end

  def create_charge_token
    token = Stripe::Token.create(
      { customer: @order.stripe_customer_token },
      @key
    )
  rescue Stripe::InvalidRequestError => e
    Rails.logger.error "Stripe error while creating token: #{e.message}"
  end

  def charge_customer
    total = (@order.total * 100).to_i
    fee = @order.total.round
    token = create_charge_token
    charge = Stripe::Charge.create(
      {
        amount: total,
        currency: "usd",
        card: token["id"],
        description: "testing 3rd party charges",
        application_fee: fee
      }, @key
    )
  rescue Stripe::CardError => e
    Rails.logger.error "Stripe error while creating customer: #{e.message}"
    return nil
  end
end