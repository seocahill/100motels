module Components
  class CheckoutForm < CapybaraPageObject::Form
  
    def name=(name)
      source.fill_in 'Name', :with => name
    end

    def email=(email)
      source.fill_in 'Email', :with => email
    end

    def place_order!
      source.click_button 'Place Order'
    end
  end
end