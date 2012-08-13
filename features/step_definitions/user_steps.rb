Given /^there are the following users:$/ do |table|
  table.hashes.each do |attributes|
    admin = attributes["admin"]
    attributes.delete("admin")
    unconfirmed = attributes.delete("unconfirmed") == "true"
    @user = User.create!(attributes)
    #@user.update_column("admin", attributes["admin"] == "true")
    @user.admin = admin
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

Given /^I am signed in as "([^\"]*)"$/ do |email|
  @user = User.find_by_email!(email)
  steps("Given I am signed in as them")
end


