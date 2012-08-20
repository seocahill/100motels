module Components
  class OrdersTableRow
    
    def initialize(row)
      @row = row
    end
    
    NAME_COLUMN_INDEX = 0
    EMAIL_COLUMN_INDEX = 1


    def name
      @row.all('td')[NAME_COLUMN_INDEX].text
    end

    def email
      @row.all('td')[EMAIL_COLUMN_INDEX].text
    end
    
  end
end