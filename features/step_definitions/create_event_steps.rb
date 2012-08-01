Given /^I am on the events index page$/ do
  visit events_index_path
end


Then /^I should see "(.*?)"$/ do |arg1|
  page.should have_content arg1
end
