Given /^there are (#{CAPTURE_A_NUMBER}) events:$/ do |n|
  @events = n.times.map { FactoryGirl.create(:event) }
end

Given /^there are (#{CAPTURE_A_NUMBER}) users:$/ do |n|
  @users = n.times.map { FactoryGirl.create(:user, admin: false) }
end

And /^I visit the homepage$/ do
  @page = Pages::Home.visit
end

Then /^those users should be listed$/ do
  @page.promoter_names.should == @users.map{ |p| p.email }
end