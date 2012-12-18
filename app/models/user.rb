class User < ActiveRecord::Base
  # serialize :customer_details, ActiveRecord::Coders::Hstore
  rolify

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
  :name, :avatar, :media, :new_location, :location_id, :guest_id

  attr_accessor :new_location

  has_many :requests, dependent: :destroy
  has_many :organizers, through: :requests
  has_many :orders
  has_one :location, dependent: :destroy
  has_one :profile, dependent: :destroy
  belongs_to :location


  scope :total_events

  %w[livemode type exp_month country exp_year cvc_check].each do |key|
    # attr_accessible key
    scope "has_#{key}", lambda { |value| where("customer_details @> (? => ?)", key, value) }

    define_method(key) do
      customer_details && customer_details[key]
    end

    define_method("#{key}=") do |value|
      self.customer_details = (customer_details || {}).merge(key => value)
    end
  end


  def self.from_omniauth(auth, user)
      user.profile.api_key = auth.credentials["token"]
      user.profile.save
      user
  end

  # auto_html_for :media do
  #   html_escape
  #   youtube(:width => 630, :height => 430)
  #   vimeo(:width => 630, :height => 430)
  #   soundcloud(:width => 630, :height => 200)
  #   link :target => "_blank", :rel => "nofollow"
  #   simple_format
  # end

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
