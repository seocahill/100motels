class ChargeCustomers

  def create_charge_token(organizer)
      # create a Token from the existing customer on the application's account
    order_amount = (quantity * event.ticket_price * 100).to_i
    fee = order_amount / 100
    key = organizer.api_key
    token = Stripe::Token.create(
      {:customer => stripe_customer_token},
      key
    )
  end

  def charge_customer
    # create the charge
    charge = Stripe::Charge.create(
      {
        :amount => order_amount,
        :currency => "usd",
        :card => token["id"],
        :description => "testing 3rd party charges",
        :application_fee => fee
      }, key
    )
  end

  def handle_charge_reponse
    # update the order to reflect the response
    self.stripe_charge_id = charge.id
    self.stripe_event = :paid
    save!
  rescue Stripe::CardError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    self.stripe_event = :failed
    save
    false
  end

end