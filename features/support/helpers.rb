#Env variable for passing integers to stepdefs

CAPTURE_A_NUMBER = Transform /^\d+$/ do |number|
  number.to_i
end

# After hook to show failing features in the browser
# Call with LAUNCHY=true cucumber

After do |scenario|
  save_and_open_page if scenario.status == :failed && ENV['LAUNCHY'].present?
end