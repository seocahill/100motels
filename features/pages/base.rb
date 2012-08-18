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
    
    def event_titles
      all('#events .title').collect(&:text)
    end

    def add_event(title)
      header = find('li', :text => title)
      event_div = header.find(:xpath, '..')
      event_div.click_button 'Add to Cart'
    end

  end
end