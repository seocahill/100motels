module Pages
  class Base < CapybaraPageObject::Page

    def cart
      Components::Cart.new find('#cart')
    end

    def checkout_available?
      cart.checkout_available?
    end

    def errors
      all('#error_explanation ul li').collect(&:text)
    end

    def notice
      find('#notice').text
    end
    
    def add_event(title)
      header = find('h3', :text => title)
      entry = header.find(:xpath, '..') # TODO why doesn't parent work here?
      entry.click_button 'Add to Cart'
    end

  end
end