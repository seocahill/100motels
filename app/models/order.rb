class Order < ActiveRecord::Base

  attr_accessible :email, :name

  has_many :line_items  
  
end
