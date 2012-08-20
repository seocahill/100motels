module Pages
  module Orders
    class New < Pages::Base
      path 'orders/new'

      def checkout_form
        Components::CheckoutForm.new(find('.order_form'))
      end

    end
  end
end