class EventUser < ActiveRecord::Base
  belongs_to :event
  belongs_to :user
  attr_accessible :user_id
end
