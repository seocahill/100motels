class EventUser < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  # attr_accessible :user_id, :state, :event_id, :payment_lock, :email
  attr_accessor :email
  enum_accessor :state, [ :reader, :editor, :event_admin, :organizer ]
  validate :forbid_existing_user, on: :create

  def forbid_existing_user
    user = User.find(self.user_id)
    if user.event_users.exists?(event_id: self.event_id)
      errors.add(:event_id, "can't add the same user twice!")
    end
  end
end