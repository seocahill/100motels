class EventUser < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  attr_accessible :user_id, :state, :event_id, :payment_lock, :email
  attr_accessor :email
  enum_accessor :state, [ :reader, :editor, :event_admin, :organizer ]
  validate :forbid_two_organizers, on: :save

  def forbid_two_organizers
    event = self.event
    if event.event_users.any? {|eu| eu.state_organizer?}
      errors.add(:date, "can only be one organizer!") if self.state_organizer?
    end
  end
end