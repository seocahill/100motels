# Given /^there are the following users:$/ do |table| 
#   table.hashes.each do |attributes|
#     confirm_user = attributes.delete("confirm_user") 
#     @user = User.create!(attributes.merge!( :password_confirmation => attributes[:password]))
    
#     if( confirm_user == "true" )
#       @user.confirm!
#     end
#   end
# end

Given /^there are the following users:$/ do |table|
  table.hashes.each do |attributes|
    admin = attributes.delete("admin")
    unconfirmed = attributes.delete("unconfirmed") == "true"
    @user = User.create!(attributes)
    @user.update_column("admin", attributes["admin"] == "true")
    @user.admin = true
    @user.confirm! unless unconfirmed
  end
end

Given /^I am signed in as them$/ do
  # save_and_open_page
  steps(%Q{
    Given I am on the Events index page
    When I click "Sign in"
    And I fill in "Email" with "#{@user.email}"
    And I fill in "Password" with "foobar"
    And I press "Sign in"
    Then I should see "Signed in successfully."
    })

end


