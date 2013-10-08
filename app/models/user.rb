class User < ActiveRecord::Base
  enum_accessor :state, [ :unconfirmed, :normal, :suspended, :god, :beta ]

  has_many :event_users
  has_many :events, through: :event_users

  before_create :generate_token

  scope :total_events

  has_secure_password

  def guest?
    false
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while self.class.exists?(column => self[column])
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.delay.password_reset(self.id)
  end

  def send_admin_invitation(inviter_id, event_id)
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.delay.event_admin_invite(self.id, inviter_id, event_id)
  end

  def customer_id?
    false
  end

  def confirm!
    generate_token(:email_confirm_token)
    self.email_confirm_sent_at = Time.zone.now
    save!
    UserMailer.delay.email_confirmation(self.id)
  end

  def generate_token
    begin
      self.auth_token = SecureRandom.urlsafe_base64
    end while User.exists?(auth_token: auth_token)
  end

  def connect(request)
    auth = request.env["omniauth.auth"]
    self.api_key = auth.credentials["token"]
    save!
  end
end
