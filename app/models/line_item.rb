class LineItem < ActiveRecord::Base
  belongs_to :event
  belongs_to :cart
  belongs_to :order

  attr_accessible :event_id, :quantity

  def line_total_price
    quantity * event.ticket_price
  end

end
