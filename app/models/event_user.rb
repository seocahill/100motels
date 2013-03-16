class EventUser < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  attr_accessible :user_id, :state, :event_id, :payment_lock, :email
  attr_accessor :email
  enum_accessor :state, [ :reader, :editor, :event_admin, :organizer ]
  validate :forbid_two_organizers, on: :save
  validate :forbid_existing_user, on: :create
  # validates :email, presence: :true

  def forbid_two_organizers
    if self.event.event_users.any? {|eu| eu.state_organizer?}
      errors.add(:state, "can only be one organizer!") if self.state_changed?
    end
  end

  def forbid_existing_user
    if self.user.event_users.include? self
      errors.add(:date, "can't add a user twice!")
    end
  end
end