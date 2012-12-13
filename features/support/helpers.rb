#Env variable for passing integers to stepdefs

CAPTURE_A_NUMBER = Transform /^\d+$/ do |number|
  number.to_i
end

Then /^show me the page$/ do
  save_and_open_page
end

Then /^grab the page$/ do
  visit("http://google.com")
  page.driver.render('./screen.png', :full => true)
end

