class MemberProfile < ActiveRecord::Base
  has_one :user, as: :profile, dependent: :destroy
  accepts_nested_attributes_for :user

  attr_accessible :auth_token, :avatar, :confirmation_sent_at, :confirmation_token,
   :email, :name, :password, :password_reset_sent_at, :password_reset_token

  validates :email, presence: :true, uniqueness: :true
  validates_format_of :email, with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

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
end
