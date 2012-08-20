module Pages
  module Orders
    class Show < Pages::Base
      path 'orders/show'

      def order_items
        all('#events .title').collect(&:text)
      end

      def order_details
        all('#events .title').collect(&:text)
      end

    end
  end
end