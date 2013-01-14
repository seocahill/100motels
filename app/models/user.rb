class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable
  attr_accessible :email, :password, :password_confirmation, :remember_me,
  :name, :avatar, :media, :new_location, :location_id, :guest_id, :uid, :provider
  attr_accessor :new_location
  attr_encrypted :api_key, key: ENV['ATTR_ENCRYPTED_KEY']

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

  auto_html_for :media do
    html_escape
    youtube(:width => 630, :height => 430)
    vimeo(:width => 630, :height => 430)
    soundcloud(:width => 630, :height => 200)
    link :target => "_blank", :rel => "nofollow"
    simple_format
  end
end
