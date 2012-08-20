module Pages
  module Orders
    class New < Pages::Base
      path 'orders/new'

      def checkout_form
        Components::CheckoutForm.new(find('.new_order'))
      end

    end
  end
end