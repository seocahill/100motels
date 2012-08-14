class LineItem < ActiveRecord::Base
  belongs_to :event
  belongs_to :cart
  
  attr_accessible :event_id

  def line_total_price
    quantity * event.ticket_price
  end

end
