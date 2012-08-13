Then /^my cart should be empty$/ do
  @page.cart.should be_empty
end

When /^I add an event to my cart$/ do 
  click_button("Add to Cart")
end

Then /^my cart should contain one item$/ do 
  @cart.line_items.count.should == 1
end

Given /^my cart contains events$/ do
  add_some_events_to_cart
end

Given /^my cart is empty$/ do
  # no-op
end

When /^I empty my cart$/ do
  @page.cart.empty!
end

Given /^there are current events$/ do
  @events = []
  2.times { @events << FactoryGirl.create(:event) }
end

def add_some_events_to_cart
  @events = []
  2.times { @events << FactoryGirl.create(:event) }
  @page = Pages::Home.visit
  @events.each do |event|
    @page.add_event event.artist
  end
end

