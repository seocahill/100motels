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
    When I follow "Admin"
    And I follow "Users"

  Scenario: Deleting a user
    And I follow "user@creteboom.com"
    When I follow "Delete User"
    Then I should see "User has been deleted"
    
  Scenario: A user cannot delete themselves
    When I follow "admin@creteboom.com"
    And I follow "Delete User"
    Then I should see "You cannot delete yourself!"