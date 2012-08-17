Then /^my cart should be empty$/ do
  @page.cart.should be_empty
end

When /^I add "(.*?)" to my cart$/ do |event_title|
  @page.add_event event_title
end

When /^I add "(.*?)" to my cart again$/ do |event_title|
  @page.add_event event_title
end

Then /^my cart should contain:$/ do |table|
  @page.cart.contents.should == table.hashes
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
  2.times { @events << FactoryGirl.create(:event) }
  @page = Pages::Events::Index.visit
  @events.each do |event|
    @page.add_event event.artist
  end
end