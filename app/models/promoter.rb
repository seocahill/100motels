class Promoter < ActiveRecord::Base
  belongs_to :user
  attr_accessible :promoter_name, :state
end
