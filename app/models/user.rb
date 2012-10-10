class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
   :provider, :uid, :public_key, :name, :avatar
  attr_encrypted :api_key, key: ENV['ATTR_ENCRYPTED_KEY']

  has_and_belongs_to_many :events
  # has_many :orders

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid, :public_key, :api_key)).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.public_key = auth.info["stripe_publishable_key"]
      user.api_key = auth.credentials["token"]
      Stripe.api_key = auth.credentials["token"]
      account = Stripe::Account.retrieve()
      user.email = account.email
    end

  end

  def self.new_with_session(params, session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"], without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

  def to_s
    "#{email} (#{admin? ? "Admin" : "User"})"
  end
end
