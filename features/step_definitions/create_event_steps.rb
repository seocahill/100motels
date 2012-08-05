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
