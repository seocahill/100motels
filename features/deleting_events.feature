Feature: Deleting events
	In order to remove old events
	As an admin user
	I want to make them disappear

	Background:
		Given there are the following users:
		| email								| password | admin |
		| admin@creteboom.com | foobar   | true  |
		And I am signed in as them

	Scenario: Deleting an event
		Given that there is an event for the Artist "Crete Boom"
		And I am on the Events index page
		When I click "Event Details"
		And I click "Delete Event"
		Then I should see "Event has been deleted"
		Then I should not see "Crete Boom"
