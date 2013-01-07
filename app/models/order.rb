class Order < ActiveRecord::Base
  attr_accessible :email, :name, :quantity, :event_id, :user_id
  enum_accessor :stripe_event, [ :pending, :paid, :failed, :refunded, :cancelled, :dummy ]
  belongs_to :event
  belongs_to :user
  validates :email, presence: :true
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validates :quantity, numericality: :true

  scope :sales_today, where("orders.created_at >= ?", Time.now.yesterday)
  scope :pending, where("stripe_event = ?", 0)
  scope :paid, where("stripe_event = ?", 1)
  scope :failed, where("stripe_event = ?", 2)
  scope :refunded, where("stripe_event = ?", 3)
  scope :cancelled, where("stripe_event = ?", 4)
  scope :total, where("stripe_event <= ?", 1)

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

  def charge_customer(organizer)
      # create a Token from the existing customer on the application's account
    order_amount = (quantity * event.ticket_price * 100).to_i
    fee = order_amount / 100
    key = organizer.api_key
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
        :application_fee => fee
      }, key
    )
    #update the order to reflect the response
    # self.stripe_charge_id = charge.id
    # self.stripe_event = :paid
    # save!
  rescue Stripe::CardError => e
    logger.error "Stripe error while creating customer: #{e.message}"
    self.stripe_event = :failed
    save
    false
  end

  def refund_customer(organizer)
    Stripe.api_key = organizer.api_key
    ch = Stripe::Charge.retrieve(stripe_charge_id) #need to pass in charge object here
    refund = ch.refund
    if refund[:refunded] == true
      self.stripe_event = :refunded
      save!
    end
  end

  def total(event)
    quantity * event.ticket_price
  end

  def banked
    gross = quantity * event.ticket_price
    bank_charges = (gross / 100) * 2.9 + 0.30
    motel_fee = gross / 100
    banked = gross - bank_charges - motel_fee
  end
end
