class User < ActiveRecord::Base
  rolify
  # before_update { user.build_location if user.location.empty? }

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
  :name, :avatar, :last4, :media, :location_id, :new_location

  attr_accessor :new_location

  has_many :requests, foreign_key: :profile_id, dependent: :destroy
  has_many :promoters, through: :requests
  has_one :location, dependent: :destroy
  has_one :profile, dependent: :destroy
  belongs_to :location

  scope :promoter_city, proc { |city| joins(:location).where("city = ?", city) }
  scope :total_events

  def create_location
    self.location = Location.create(address: new_location) if new_location.present?
  end


  def self.from_omniauth(auth, user)
      user.provider = auth.provider
      user.uid = auth.uid
      user.profile.api_key = auth.credentials["token"]
      user.profile.save
      user.save!
      user
  end

  auto_html_for :media do
    html_escape
    youtube(:width => 630, :height => 430)
    vimeo(:width => 630, :height => 430)
    soundcloud(:width => 630, :height => 200)
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end

  def save_card(user, card)
    if valid?
      Stripe.api_key = ENV['STRIPE_API_KEY']
      customer = Stripe::Customer.create(
          description: user.name,
          email: user.email,
          card: card
      )
      user.customer_id = customer.id
      user.last4 = customer.active_card["last4"]
      user.save!
    end
  rescue Stripe::InvalidRequestError => e
    flash[:error] = e.message
    redirect_to user_path(user)
  end
end
