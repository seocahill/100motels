Then /^my cart should be empty$/ do
  @page.cart.should be_empty
end

When /^I add "(.*?)" to my cart$/ do |event_title|
  click_button('Add to Cart')
end

When /^I add "(.*?)" to my cart again$/ do |event_title|
  @page.add_event(event_title)
end

Then /^my cart should contain:$/ do |table|
  click_link('Cart (1)')
  click_link('View Cart')
  @page.contents.should == table.hashes
end

Given /^my cart contains events$/ do
  add_some_events_to_cart
end

Given /^my cart is empty$/ do
  @page.cart.should be_empty
end

When /^I empty my cart$/ do
  @page.cart.empty!
end

def add_some_events_to_cart
  @events = []
  2.times { @events << FactoryGirl.create(:event, artist: "Crete Boom") }
  @page = Pages::Events::Index.visit
  @events.each do |event|
    @page.add_event event.artist
  end
end