class EventUser < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  attr_accessible :user_id, :state, :event_id
  attr_accessor :email
  enum_accessor :state, [ :reader, :editor, :event_admin, :organizer ]
end