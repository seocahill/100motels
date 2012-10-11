class Order < ActiveRecord::Base
  attr_accessible :email, :name, :last_four, :plan, :quantity, :event_id
  belongs_to :events
  validates :email, presence: :true
  validates :quantity, numericality: :true

  attr_accessor :stripe_card_token


  def save_customer(promoter, token)
    if valid?
      Stripe.api_key = promoter.api_key
      customer = Stripe::Customer.create(
        description: name,
        email: email,
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

  def total(event)
    quantity * event.ticket_price
  end
end
