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
end

Then /^the customers details should be captured$/ do
end

Then /^the order should not be placed$/ do
end

module CheckoutHelpers
  def checkout_with_valid_details
    @page = Pages::Home.visit
    @cart = @page.cart
    @page.cart.checkout!
    @form = Pages::Orders::New.visit.checkout_form
    @customer = {
      :name => 'Joe Bloggs',
      :email => 'joe@example.com'
    }
    @form.name = @customer[:name]
    @form.email = @customer[:email]
  end
end

World(CheckoutHelpers)