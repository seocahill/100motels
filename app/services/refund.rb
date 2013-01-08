class Refund

  def refund_customer(organizer)
    Stripe.api_key = organizer.api_key
    ch = Stripe::Charge.retrieve(stripe_charge_id) #need to pass in charge object here
    refund = ch.refund
    if refund[:refunded] == true
      self.stripe_event = :refunded
      save!
    end
  end

end