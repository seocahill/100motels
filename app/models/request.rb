class Request < ActiveRecord::Base
  belongs_to :user
  belongs_to :event
  belongs_to :promoter, class_name: "User"
  attr_accessible :state, :event_id, :promoter_id
end
