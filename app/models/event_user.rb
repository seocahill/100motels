class EventUser < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  enum_accessor :state, [ :reader, :editor, :event_admin, :admin ]
end