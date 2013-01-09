class ChargeCustomer

  def initialize(order, current_user)
    @order = order
    @organizer = User.find(current_user.profile.id)
    @token = []
    @charge = []
  end

  def processed?
    @order.stripe_event == :paid ?
  end

  def create_charge_token
    total = (@order.total * 100).to_i
    fee = total.round
    key = @organizer.api_key
    @token = Stripe::Token.create(
      {:customer => stripe_customer_token},
      key
    )
  end

  def charge_customer
    # create the charge
    @charge = Stripe::Charge.create(
      {
        :amount => order_amount,
        :currency => "usd",
        :card => @token["id"],
        :description => "testing 3rd party charges",
        :application_fee => fee
      }, key
    )
  rescue Stripe::CardError => e
    logger.error "Stripe error while creating customer: #{e.message}"
  end

  def handle_charge_response
    unless @charge[:failure_message]
      @order.stripe_charge_id = charge.id
      @order.stripe_event = :paid
    else
      @order.stripe_event = :failed
    end
    save
  end
end