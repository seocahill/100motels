class User < ActiveRecord::Base
  attr_encrypted :api_key, key: ENV['ATTR_ENCRYPTED_KEY']

  has_many :orders
  has_many :event_users
  has_many :events, through: :event_users
  belongs_to :profile, polymorphic: true
  # belongs_to :location

  scope :total_events

  delegate :guest?, :customer_id?, :your_account_or_email, :send_password_reset, :become_member,
    to: :profile
end
