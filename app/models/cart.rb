class Cart < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  
  attr_accessible :event_id

  def add_event(event_id)
    current_item = line_items.find_by_event_id(event_id)
    if current_item
      current_item.quantity += 1
    else
      current_item = line_items.build(event_id: event_id)
    end
    current_item
  end

  def total_price
    line_items.to_a.sum { |item| item.line_total_price}
  end

end
