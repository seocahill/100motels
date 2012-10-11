class Order < ActiveRecord::Base
  attr_accessible :email, :name, :last_four, :plan, :quantity, :event_id
  belongs_to :events
  validates :email, presence: :true
  validates :quantity, numericality: :true

  attr_accessor :last_four

  # def get_promoter(cart)
  #   id = cart.line_items.first.event_id
  #   event = Event.find_by_id(id)
  #   promoter = User.find_by_id(event.promoter_id)
  # end

  def add_line_items_from_cart(cart)
      cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  def mark_purchased
    self.line_items.each do |item|
      item.purchased = true
      item.save!
    end
  end

  def save_customer(promoter, token)
    if valid?
      Stripe.api_key = promoter.api_key
      customer = Stripe::Customer.create(
        description: name,
        # email: email,
        card: token
      )
      self.stripe_customer_token = customer.id
      saved_customer = Stripe::Customer.retrieve(customer.id)
      self.name = saved_customer.active_card["name"]
      self.last_four = saved_customer.active_card["last4"]
      save!
    end
  rescue Stripe::InvalidRequestError => e
    flash[:error] = e.message
    redirect_to(:back)
  end
  # rescue Stripe::InvalidRequestError => e
  #     logger.error "Stripe error while creating customer: #{e.message}"
  #     errors.add :base, "There was a problem with your credit card."
  #     false
  # end
end
