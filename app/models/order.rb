class Order < ActiveRecord::Base
  attr_accessible :email, :name, :stripe_card_token, :plan
  has_many :line_items, dependent: :destroy
  has_many :events, through: :line_items
  validates :name, :email, presence: :true

  attr_accessor :stripe_card_token

  def add_line_items_from_cart(cart)
      cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  def save_with_payment
    if valid?
      customer = Stripe::Customer.create(description: email, plan: plan, card: stripe_card_token)
      self.stripe_customer_token = customer.id
      save!
    end
  rescue Stripe::InvalidRequestError => e
      logger.error "Stripe error while creating customer: #{e.message}"
      errors.add :base, "There was a problem with your credit card."
      false
  end
end
