Feature: View the homepage
	In order to make sure the app is loading
	As a visitor to 100 Motels
	I should see the homepage

	 Background:
   Given there are the following users:
     | email               | password | admin | 
     | admin@creteboom.com | foobar   | true  |
     | user@creteboom.com  | foobar   | false |
   
	Scenario: Homepage should have App name
		Given I am on the homepage
		Then I should see "100 Motels"

	Scenario: Homepage link to view users
		Given I am on the homepage
		And I click "Users Index"
		Then I should see "admin@creteboom.com (Admin)"
		And I should see "user@creteboom.com (User)"