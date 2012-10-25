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
   :provider, :uid, :public_key, :name, :avatar, :last4, :media
  attr_encrypted :api_key, key: ENV['ATTR_ENCRYPTED_KEY']

  has_many :requests
  has_many :events, through: :requests
  has_one :location, dependent: :destroy
  has_one :profile, dependent: :destroy


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
end
