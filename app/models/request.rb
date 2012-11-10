class Request < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  belongs_to :promoter, class_name: "User"
  attr_accessible :event_id, :promoter_id
  enum_accessor :state, [:unread, :read, :email_sent]

  scope :unread, where("state = ?", 0)
end
