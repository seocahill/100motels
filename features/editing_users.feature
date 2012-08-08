Feature: Editing a user
  In order to change a user's details
  As an admin
  I want to be able to modify them through the backend

Background:
  Given there are the following users:
    | email               | password | admin | 
    | admin@creteboom.com | foobar   | true  |
  And I am signed in as them

  Given there are the following users:
    | email              | password |
    | user@creteboom.com | foobar   |
  Given I am on the Events index page
  When I click "Admin"
  And I click "Users"
  And I click "user@creteboom.com"
  And I click "Edit User"
       
Scenario: Updating a user's details
  When I fill in "Email" with "newguy@creteboom.com"
  And I press "Update User"
  Then I should see "User has been updated."
  And I should see "newguy@creteboom.com"
  And I should not see "user@creteboom.com"
       
Scenario: Toggling a user's admin ability
  When I check "Is an admin?"
  And I press "Update User"
  Then I should see "User has been updated."
  And I should see "user@creteboom.com (Admin)"

Scenario: Updating with an invalid email fails
  When I fill in "Email" with "fakefakefake"
  And I press "Update User"
  Then I should see "User has not been updated."
  And I should see "Email is invalid"