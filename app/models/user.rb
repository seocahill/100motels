class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

  attr_accessible :email, :password, :password_confirmation, :remember_me,
  :name, :avatar, :media, :new_location, :location_id, :guest_id, :uid, :provider

  attr_encrypted :api_key, key: ENV['ATTR_ENCRYPTED_KEY']

  attr_accessor :new_location

  include EmbedMedia

  has_many :orders
  belongs_to :location

  scope :total_events

  # Set Hstore attributes
  %w[livemode type exp_month country exp_year cvc_check].each do |key|
    scope "has_#{key}", lambda { |value| where("customer_details @> (? => ?)", key, value) }

    define_method(key) do
      customer_details && customer_details[key]
    end

    define_method("#{key}=") do |value|
      self.customer_details = (customer_details || {}).merge(key => value)
    end
  end

  def self.from_omniauth(auth, user)
    user.api_key = auth.credentials["token"]
    user.save
    user
  end

  def save_card(user, card)
    Stripe.api_key = ENV['STRIPE_API_KEY']
    if user.customer_id
      customer = Stripe::Customer.retrieve(user.customer_id)
      customer.description = "Update card for #{user.email}"
      customer.card = card
      customer.save
    else
      customer = Stripe::Customer.create(
          description: user.name,
          email: user.email,
          card: card
        )
      user.customer_id = customer.id
    end
    user.livemode = customer.livemode
    user.type = customer.active_card["type"]
    user.exp_year = customer.active_card["exp_year"]
    user.exp_month = customer.active_card["exp_month"]
    user.country = customer.active_card["country"]
    user.cvc_check = customer.active_card["cvc_check"]
    user.last4 = customer.active_card["last4"]
    user.save
  end
end
