class User < ActiveRecord::Base
  has_secure_password

  attr_accessible :email, :password, :remember_me
  attr_encrypted :api_key, key: ENV['ATTR_ENCRYPTED_KEY']

  validates :email, presence: :true, uniqueness: :true
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

  has_many :orders
  has_many :events_users
  has_many :events, through: :events_users
  # belongs_to :location

  scope :total_events
end
