class Order < ActiveRecord::Base
  attr_accessible :email, :name, :last_four, :plan, :quantity, :event_id
  belongs_to :events
  validates :email, presence: :true
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :quantity, numericality: :true

  attr_accessor :last_four


  def save_customer(promoter, token)
    if valid?
      Stripe.api_key = ENV['STRIPE_API_KEY']
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

  def charge_customer(order, promoter)
      # create a Token from the existing customer on the application's account
      token = Stripe::Token.create(
        {:customer => order.stripe_customer_token},
        promoter.api_key # # user's access token from the Stripe Connect flow
      )
      Stripe::Charge.create(
        {
          :amount => 1000, #fix
          :currency => "usd",
          :card => token, # obtained above
          :description => order.email,
          :application_fee => 100
        },  promoter.api_key
      )
  end

  def total(event)
    quantity * event.ticket_price
  end
end
