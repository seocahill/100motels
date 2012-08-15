#save_and_open_page

Given /^that there is an event for the Artist "(.*?)"$/ do |arg1|
  FactoryGirl.create(:event, :artist => arg1)
end

When /^I create an event with valid input$/ do
  fill_in "Artist", :with => "Crete Boom"
  fill_in "Venue", :with => "Ballina"
  fill_in "Date", :with => "21st January 2013"
  fill_in "Ticket Price", :with => "10"
  click_button("Create Event")
end

Given /^the events:$/ do |table|
  @events = table.raw.flatten.map { |p| FactoryGirl.create(:event, :artist=> p) }
end

When /^I visit the box office$/ do
  @page = Pages::Events::Index.visit
end

Then /^those events should be listed$/ do
  @page.event_titles.should == @events.map{ |p| p.artist }
  #@events.count.should == 2
end