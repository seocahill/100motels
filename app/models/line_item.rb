class LineItem < ActiveRecord::Base
  belongs_to :event
  belongs_to :cart
  # attr_accessible :title, :body
end
