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
     And I click "Users Admin"
     Then I should see "100 Motels user admin area"

   Scenario: A user cannot delete themselves

     Given I am on the admin users page
     When I click "admin@creteboom.com (Admin)"
     And I click "Delete User"
     Then I should see "You cannot delete yourself!"