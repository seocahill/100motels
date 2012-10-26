class Request < ActiveRecord::Base
  belongs_to :user
  belongs_to :promoter, class_name: "User"
  attr_accessible :state
end
