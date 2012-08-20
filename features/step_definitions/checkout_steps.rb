Given /^I am checking out with valid details$/ do
  add_some_events_to_cart
  checkout_with_valid_details
end

Then /^I should not be able to check out$/ do
  @page = Pages::Orders::New.visit
  @page.checkout_available?.should be_false
end

When /^I check out with valid details$/ do
  checkout_with_valid_details
  @form.place_order!
end

When /^I leave the (name|email) blank$/ do |missing_field|
  @missing_field = missing_field
  sym_for_field = "#{missing_field.gsub(' ', '_')}=".to_sym
  @form.send(sym_for_field, '') # TODO is there a nicer way of doing this?
end

When /^I attempt to place the order$/ do
  @form.place_order!
end

When /^I attempt to place an order$/ do
  @page.cart.checkout!
end

Then /^the order should be placed$/ do
  @page.notice.should match "thanks, enjoy the show!"
end

Then /^the customers details should be captured$/ do
  order_table = all('#order-details').collect(&:text)
  order_table.should have_content(@order[:name])
  order_table.should have_content(@order[:email])
end

Then /^the order should not be placed$/ do
  page.should have_content(text)
end

Given /^(?:I|they|a customer) has? successfully checked out$/ do
  steps(%Q{
    Given my cart contains events
    When I check out with valid details
    Then the order should be placed
    And the customers details should be captured
    })
end

Then /^I should see my order details$/ do
  order_table = all('#order-details').collect(&:text)
  order_table.should have_content(@order[:name])
  order_table.should have_content(@order[:email])
  order_table.should have_content("Rock and Roll!")
end

module CheckoutHelpers
  def checkout_with_valid_details
    @page = Pages::Home.visit
    @cart = @page.cart
    @page.cart.checkout!
    @form = Pages::Orders::New.visit.checkout_form
    @order = {
      :name => 'Joe Bloggs',
      :email => 'joe@example.com'
    }
    @form.name = @order[:name]
    @form.email = @order[:email]
  end
end

World(CheckoutHelpers)