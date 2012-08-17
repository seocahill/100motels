module Components
  class Cart < CapybaraPageObject::Node
    def empty?
      rows.empty?
    end

    def empty!
      source.click_button('Empty cart')
    end

    def checkout!
      source.click_button('Checkout')
    end
    
    def checkout_available?
      # TODO can this be improved?
      source[:style] != "display: none"
    end

    def contents
      rows.map do |row|
        {'event' => row.event, 'quantity' => row.quantity}
      end
    end

    private

    def rows
      all('table tr:not(.total_line)').map do |row|
        Components::CartRow.new(row)
      end
    end
  end
end