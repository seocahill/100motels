Given /^there are (#{CAPTURE_A_NUMBER}) events:$/ do |n|
  @events = n.times.map { FactoryGirl.create(:event, :visible, artist: "Crete Boom") }
end

Given /^there are (#{CAPTURE_A_NUMBER}) organizers:$/ do |n|
  @users = n.times.map { FactoryGirl.create(:profile, promoter_name: "Jimmy McGee") }
end

And /^I visit the homepage$/ do
  visit root_path
end

Then /^I should see "(.*?)"$/ do |arg1|
  page.should have_content(arg1)
end

Then /^the organizers should be listed$/ do
  page.should have_content("Jimmy McGee")
end

Then /^the events should be listed$/ do
  page.should have_content("Crete Boom")
end
