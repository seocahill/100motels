class Order < ActiveRecord::Base
  attr_accessible :email, :name, :plan, :quantity, :event_id, :user_id
  enum_accessor :stripe_event, [ :pending, :paid, :failed, :refunded, :cancelled, :dummy ]
  belongs_to :event
  validates :email, presence: :true
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :quantity, numericality: :true

  scope :sales_today, where("orders.created_at >= ?", Time.now.yesterday)
  scope :sales_average, where("orders.created_at >= ?", Time.now.yesterday)

  def self.recent_sales(current_user)
    events = Event.where(profile_id: current_user.profile.id)
    where(events.include?(:event_id)).order('created_at DESC').limit(5)
  end

  def save_customer(token)
    if valid?
      Stripe.api_key = ENV['STRIPE_API_KEY']
      customer = Stripe::Customer.create(
          email: email,
          card: token
      )
      self.stripe_customer_token = customer.id
      self.name = customer.active_card["name"]
      self.last4 = customer.active_card["last4"]
      if user_id
        user = User.find(user_id)
        user.customer_id = customer.id
        user.last4 = customer.active_card["last4"]
        user.cvc_check = customer.active_card["cvc_check"]
        user.type = customer.active_card["type"]
        user.exp_year = customer.active_card["exp_year"]
        user.exp_month = customer.active_card["exp_month"]
        user.save
      end
      save!
    end
  rescue Stripe::InvalidRequestError => e
    flash[:error] = e.message
    redirect_to(:back)
  end

  def customer_order
    user = User.find(user_id)
    self.user_id = user.id
    self.name = user.name || user.email
    self.email = user.email
    self.last4 = user.last4
    self.stripe_customer_token = user.customer_id
    save!
  end

  def charge_customer(promoter)
      # create a Token from the existing customer on the application's account
    order_amount = (quantity * Event.find(event_id).ticket_price * 100).to_i
    key = promoter.api_key
    token = Stripe::Token.create(
      {:customer => stripe_customer_token},
      key
    )
    # create the charge
    charge = Stripe::Charge.create(
      {
        :amount => order_amount,
        :currency => "usd",
        :card => token["id"],
        :description => "testing 3rd party charges",
        :application_fee => 100
      }, key
    )
    #update the order to reflect the response
    self.stripe_charge_id = charge[:id]
    self.stripe_event = :paid
    save!
  end

  def refund_customer(promoter)
    Stripe.api_key = promoter.api_key
    ch = Stripe::Charge.retrieve(stripe_charge_id) #need to pass in charge object here
    refund = ch.refund
    if refund[:refunded] == true
      self.stripe_event = :refunded
      save!
    end
  end

  def total(event)
    quantity * event.ticket_discount
  end
end
