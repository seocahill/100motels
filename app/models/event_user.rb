class EventUser < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  attr_accessible :user_id, :state, :event_id, :payment_lock, :email
  attr_accessor :email
  enum_accessor :state, [ :reader, :editor, :event_admin, :organizer ]
  # validate :forbid_two_organizers, on: :save
  validate :forbid_existing_user, on: :create
  validate :forbid_organizer, on: :update

  def forbid_two_organizers
    event = Event.find(self.event_id)
    if event.event_users.exists?(state: :organizer)
      errors.add(:state, "can't be set to organizer this way, please contact support!") if self.state_organizer?
    end
  end

  def forbid_existing_user
    user = User.find(self.user_id)
    if user.event_users.exists?(event_id: self.event_id)
      errors.add(:event_id, "can't add the same user twice!")
    end
  end

  def forbid_organizer
    if self.state_organizer?
      errors.add(:state, "can't be set to organizer this way, please contact support!")
    end
  end
end