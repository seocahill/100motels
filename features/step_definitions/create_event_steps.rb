Given /^I am on the events index page$/ do
  visit events_path
end

When /^I follow "(.*?)"$/ do |arg1|
	visit new_event_path
end

When /^I fill in "([^\"]*)" with "([^\"]*)"$/ do |field, value|
	fill_in(field.gsub(' ', '_'), :with => value)
end

When /^I press "(.*?)"$/ do |arg1|
  pending # express the regexp above with the code you wish you had
end

