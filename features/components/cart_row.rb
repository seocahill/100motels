module Components
  class CartRow < CapybaraPageObject::Node

    # table doesn't include IDs or class names so we'll to use to the column ordering
    QUANTITY_COLUMN_INDEX = 0
    EVENT_COLUMN_INDEX = 1

    def quantity
      multiplication_sign = "\u00d7"
      all('td')[QUANTITY_COLUMN_INDEX].text.gsub(multiplication_sign, '') # the 1st column in the table
    end
    
    def event
      all('td')[EVENT_COLUMN_INDEX].text # the 2nd column in the table
    end
  end
end