class Promoter < ActiveRecord::Base
  attr_accessible :promoter_name, :references, :state
end
