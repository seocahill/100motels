Given /^there are (#{CAPTURE_A_NUMBER}) events:$/ do |n|
  n.times { FactoryGirl.create(:event) }
end

Given /^there are (#{CAPTURE_A_NUMBER}) users:$/ do |n|
  n.times { FactoryGirl.create(:user, admin: false) }
end

And /^I visit the homepage$/ do
  @page = Pages::Home.visit
end

Then /^those users should be listed$/ do
  @page.promoter_names.should == @users.map{ |p| p.name }
end