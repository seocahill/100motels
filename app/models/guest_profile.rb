class GuestProfile < ActiveRecord::Base
  has_one :user, as: :profile, dependent: :destroy

  def guest?
    true
  end

  def your_account_or_email
    "your account"
  end

  def customer_id?
    false
  end
end

