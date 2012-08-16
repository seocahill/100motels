Feature: Admin
     
 In order to carry out restricted actions
 As an admin
 I want to be able to act as an admin user
     
 Background:
     
   Given there are the following users:
   | email               | password | admin | 
   | admin@creteboom.com | foobar   | true  |
   | user@creteboom.com  | foobar   | false |
   
   And I am signed in as the admin user
     
   Scenario: Accessing the Admin area
     
     Given I am on the homepage
     When I click "Admin"
     And I click "Users"
     Then I should see "100 Motels user admin area"
     
   Scenario: Creating new users from the admin area

     Given I fill out the new user form
     And I press "Create User"
     Then I should see "User has been created."
     
   Scenario: Creating an admin user

     Given I fill out the new user form
     And I check "Is an admin?"
     And I press "Create User"
     Then I should see "User has been created"
     And I should see "newbie@creteboom.com (Admin)"

   Scenario: Updating a user's details

     Given I am editing a user
     When I fill in "Email" with "newguy@creteboom.com"
     And I press "Update User"
     Then I should see "User has been updated."
     And I should see "newguy@creteboom.com"
     And I should not see "user@creteboom.com"
         
   Scenario: Toggling a user's admin ability

     Given I am editing a user
     When I check "Is an admin?"
     And I press "Update User"
     Then I should see "User has been updated."
     And I should see "user@creteboom.com (Admin)"


   Scenario: Deleting a user

     Given I am on the admin users page
     And I click "user@creteboom.com"
     When I click "Delete User"
     Then I should see "User has been deleted"
    
   Scenario: A user cannot delete themselves

     Given I am on the admin users page
     When I click "admin@creteboom.com"
     And I click "Delete User"
     Then I should see "You cannot delete yourself!"