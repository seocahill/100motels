class Order < ActiveRecord::Base
  attr_accessible :email, :name, :plan, :quantity, :event_id
  enum_accessor :stripe_event, [ :pending, :paid, :failed, :refunded, :cancelled ]
  belongs_to :events
  validates :email, presence: :true
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :quantity, numericality: :true

  attr_accessor :last_four


  def save_customer(token)
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
    order_amount = (order.quantity * Event.find(order.event_id).ticket_price * 100).to_i
    key = promoter.api_key
    token = Stripe::Token.create(
      {:customer => order.stripe_customer_token},
      key
    )

    # create the charge
    charge = Stripe::Charge.create(
      {
        :amount => order_amount,
        :currency => "usd",
        :card => token["id"],
        :description => "testing 3rd party charges",
        :application_fee => 1000
      }, key
    )
    raise charge.to_yaml
  end

  def refund_customer(order, promoter)
    Stripe.api_key = promoter.api_key
    ch = Stripe::Charge.retrieve(order) #need to pass in charge object here
    ch.refund
  end

  def total(event)
    quantity * event.ticket_price
  end
end
