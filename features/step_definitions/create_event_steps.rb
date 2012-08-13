Given /^I am on the events index page$/ do
  visit events_path
end

When /^I follow "(.*?)"$/ do |arg1|
	visit new_event_path
end

When /^I fill in "([^\"]*)" with "([^\"]*)"$/ do |field, value|
	fill_in(field.gsub(' ', '_'), :with => value)
end

When /^I press "([^\"]*)"$/ do |button|
  #save_and_open_page
  click_button(button)
end

Then /^I should see "(.*?)"$/ do |arg1|
  page.should have_content(arg1)
end

Then /^I should not see "(.*?)"$/ do |arg1|
  page.should_not have_content(arg1)
end

When /^I create an event with valid input$/ do
  fill_in "Artist", :with => "Crete Boom"
  fill_in "Venue", :with => "Ballina"
  fill_in "Date", :with => "21st January 2013"
  fill_in "Ticket Price", :with => "10"
  click_button("Create Event")
end

Given /^there are current Events$/ do
  @events = [create(:event), create(:event)]
end

Then /^tickets for those events should be available to buy$/ do
  @page.product_titles.should =~ @events.collect(&:artist)
end

Given /^the events:$/ do |table|
  table.raw.flatten.each do |p|
    create(:event, :artist => p)
  end
end