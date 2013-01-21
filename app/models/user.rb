class User < ActiveRecord::Base
  attr_encrypted :api_key, key: ENV['ATTR_ENCRYPTED_KEY']
  attr_encrypted :customer_id, key: ENV['ATTR_ENCRYPTED_KEY']

  has_many :orders
  has_many :event_users
  has_many :events, through: :event_users
  belongs_to :profile, polymorphic: true


  before_create :generate_token

  scope :total_events

  delegate :guest?, :customer_id?, :your_account_or_email, :send_password_reset, :become_member, :username,
    to: :profile

  def generate_token
    begin
      self.auth_token = SecureRandom.urlsafe_base64
    end while User.exists?(auth_token: auth_token)
  end
end
