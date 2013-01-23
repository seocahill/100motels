class GuestProfile < ActiveRecord::Base
  has_one :user, as: :profile, dependent: :destroy

  def username
    "Guest User"
  end

  def guest?
    true
  end

  def your_account_or_email
    "your account"
  end

  def customer_id?
    false
  end

  def become_member(member_profile)
    user.events.each {|e| e.state = :member }
    user.events.each(&:save)
    user.profile = member_profile
    user.save!
  end

  def send_password_reset
  end
end

