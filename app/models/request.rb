class Request < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  belongs_to :promoter, class_name: "User", foreign_key: :profile_id
  attr_accessible :event_id, :profile_id
  enum_accessor :state, [:unread, :read, :email_sent]
end
