Given /^I am on homepage$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see "(.*?)"$/ do |arg1|
  page.should have_content arg1
end
