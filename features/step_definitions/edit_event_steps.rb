Given /^that there is an event for the Artist "(.*?)"$/ do |arg1|
  FactoryGirl.create(:event, :artist => arg1)
end