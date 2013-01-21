class UpdateCard

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
    Rails.logger.error "Stripe error while updating customer: #{e.message}"
  end

  def update_user_record
    new_cards = update_card
    @user.card_type = new_cards.active_card["type"]
    @user.exp_year = new_cards.active_card["exp_year"]
    @user.exp_month = new_cards.active_card["exp_month"]
    @user.country = new_cards.active_card["country"]
    @user.cvc_check = new_cards.active_card["cvc_check"]
    @user.last4 = new_cards.active_card["last4"]
    @user.save!
  end
end