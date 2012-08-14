Feature: View the homepage

	In order to make sure the app is loading
	As a visitor to 100 Motels
	I should see the homepage

	 Background:

   Given there are the following users:
     | email               | password | admin | 
     | admin@creteboom.com | foobar   | true  |
     | user@creteboom.com  | foobar   | false |
   And that there is an event for the Artist "Crete Boom"
   And that there is an event for the Artist "The Crete Boom"

	
	Scenario: Homepage should have App name

		Given I am on the homepage
		Then I should see "100 Motels, A Place for Anarchy"

	Scenario: Homepage should list newest users

		Given I am on the homepage
		Then I should see "admin@creteboom.com (Admin)"
		And I should see "user@creteboom.com (User)"
	
	Scenario: Homepage should list latest events

		Given I am on the homepage
		Then I should see "Artist - Crete Boom"
		And I should see "Artist - The Crete Boom"
		
	