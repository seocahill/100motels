Feature: Deleting events
	In order to remove old events
	As an admin user
	I want to make them disappear

	Scenario: Deleting an event
		Given that there is an event for the Artist "Crete Boom"
		And I am on the Events index page
		When I click "Event Details"
		And I click "Delete Event"
		Then I should see "Event has been deleted"
		Then I should not see "Crete Boom"
