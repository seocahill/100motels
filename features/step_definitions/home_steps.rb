Given /^there are (#{CAPTURE_A_NUMBER}) events:$/ do |n|
  @events = n.times.map { FactoryGirl.create(:event) }
end

Given /^there are (#{CAPTURE_A_NUMBER}) organizers:$/ do |n|
  @users = n.times.map { FactoryGirl.create(:user) }
end

And /^I visit the homepage$/ do
  visit root_path
end

Then /^I should see "(.*?)"$/ do |arg1|
  page.should have_content(arg1)
end

Then /^those users should be listed$/ do
  pending
end