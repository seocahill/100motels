caclass UpdateCard

  def initialize(user, card)
    @user = user
    @card = card
  end

  def update_card
    Stripe.api_key = ENV['STRIPE_API_KEY']
    customer = Stripe::Customer.retrieve(@user.customer_id)
    customer.description = "Update card for #{@user.email}"
    customer.card = @card
    customer.save
  rescue Stripe::InvalidRequestError => e
    logger.error "Stripe error while updating customer: #{e.message}"
  end

  def update_user_record
    customer = update_card
    @user.livemode = customer.livemode
    @user.card_type = customer.active_card["type"]
    @user.exp_year = customer.active_card["exp_year"]
    @user.exp_month = customer.active_card["exp_month"]
    @user.country = customer.active_card["country"]
    @user.cvc_check = customer.active_card["cvc_check"]
    @user.last4 = customer.active_card["last4"]
    @user.save!
  end
end