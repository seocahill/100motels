Feature: Hidden Links
	In order to clean up the user experience
	As the system
	I want to hide links from users who can't act on them
	
	Background:
		Given there are the following users:
		| email							  | password | admin |
		| user@creteboom.com  | foobar   | false |
		| admin@creteboom.com | foobar	 | true  |
		And that there is an event for the Artist "Crete Boom"
	
	Scenario: New event link is hidden for non-signed-in users
		Given I am on the Events index page
		Then I should not see the "New Event" link
		
	Scenario: New event link is hidden for signed-in users
		Given I am signed in as "user@creteboom.com"
		Then I should not see the "New Event" link
		
	Scenario: New event link is shown to admins
		Given I am signed in as "admin@creteboom.com"
		Then I should see the "New Event" link
