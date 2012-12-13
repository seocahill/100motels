#Env variable for passing integers to stepdefs

CAPTURE_A_NUMBER = Transform /^\d+$/ do |number|
  number.to_i
end

Then /^show me the page$/ do
  save_and_open_page
end