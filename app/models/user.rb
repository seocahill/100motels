class User < ActiveRecord::Base

  has_secure_password

  attr_accessible :email, :password, :remember_me
  attr_encrypted :api_key, key: ENV['ATTR_ENCRYPTED_KEY']

  validates_presence_of :password, on: :create
  validates :email, presence: :true, uniqueness: :true
  validates_format_of :email, with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

  has_many :orders
  has_many :events_users
  has_many :events, through: :events_users
  # belongs_to :location

  scope :total_events

   before_create { generate_token(:auth_token) }

   def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end
end
