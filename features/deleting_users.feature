Feature: Deleting users
  In order to remove users
  As an admin
  I want to click a button and delete them

  Background:
    Given there are the following users:
      | email               | password | admin |
      | admin@creteboom.com | foobar   | true  |
      | user@creteboom.com  | foobar   | false |
      
    And I am signed in as "admin@creteboom.com"
    Given I am on the events index page
    When I click "Admin"
    And I click "Users"

  Scenario: Deleting a user
    And I click "user@creteboom.com"
    When I click "Delete User"
    Then I should see "User has been deleted"
    
  Scenario: A user cannot delete themselves
    When I click "admin@creteboom.com"
    And I click "Delete User"
    Then I should see "You cannot delete yourself!"