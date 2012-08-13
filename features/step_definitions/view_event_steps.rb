Given /^that there is an event for "(.*?)"$/ do |arg1|
  Factory(:event, :artist => arg1)
end

Given /^the events:$/ do |table|
  table.raw.flatten.each do |p|
    create(:event, :artist => p)
  end
end

Given /^I am on the Events index page$/ do
	visit events_path
end

When /^I click "(.*?)"$/ do |arg1|
	click_link(arg1)
end

Then /^I should be on the event page for "(.*?)"$/ do |arg1|
	page.should have_content(arg1)
end
