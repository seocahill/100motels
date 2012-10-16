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
    key = promoter.api_key
    token = Stripe::Token.create(
      {:customer => order.stripe_customer_token},
      key
    )

    # create the charge
    Stripe::Charge.create(
      {
        :amount => 1000,
        :currency => "usd",
        :card => token,
        :description => "testing 3rd party charges",
        :application_fee => 100
      }, key
    )
    # rescue Stripe::InvalidRequestError => e
    #   flash[:error] = e.message
    #   redirect_to(:back)
  end

  def total(event)
    quantity * event.ticket_price
  end
end
