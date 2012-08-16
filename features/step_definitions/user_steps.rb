Given /^there are the following users:$/ do |table|
  table.hashes.each do |attributes|
    admin = attributes["admin"]
    attributes.delete("admin")
    unconfirmed = attributes.delete("unconfirmed") == "true"
    @user = User.create!(attributes)
    @user.admin = admin
    @user.confirm! unless unconfirmed
  end
end

Given /^I am signed in as them$/ do
  steps(%Q{
    Given I am on the homepage
    When I click "Sign in"
    And I fill in "Email" with "#{@user.email}"
    And I fill in "Password" with "foobar"
    And I press "Sign in"
    Then I should see "Signed in successfully."
    })
end

Given /^I am signed in as the admin user$/ do
  steps(%Q{
    Given I am on the homepage
    When I click "Sign in"
    And I fill in "Email" with "admin@creteboom.com"
    And I fill in "Password" with "foobar"
    And I press "Sign in"
    Then I should see "Signed in successfully."
    })
end

Given /^I am signed in as "([^\"]*)"$/ do |email|
  @user = User.find_by_email!(email)
  steps("Given I am signed in as them")
end

Given /^I fill out the new user form$/ do
  steps(%Q{
    Given I am on the admin users page
    And I click "New User"
    And I fill in "Email" with "newbie@creteboom.com" 
    And I fill in "Password" with "foobar"
    })
end

Given /^I am editing a user$/ do
  steps(%Q{
    Given I am on the admin users page
    And I click "user@creteboom.com"
    And I click "Edit User"
    })
end
