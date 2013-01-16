class EventsUsers < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  attr_accessible :state
  enum_accessor :state, [ :read, :write ]
end
