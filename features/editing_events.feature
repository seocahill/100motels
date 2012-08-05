Feature: Editing Events
	In order to update the event information
	As a user
	I want to be able to do that through a view

	Scenario: Updating an Event
		Given that there is an event for the Artist "Crete Boom"
		And I am on the Events index page
		When I click "Event Details"
		And I click "Edit Event"
		And I fill in "Artist" with "The Crete Boom"
		And I press "Update Event"
		Then I should see "Event has been updated"
		Then I should be on the event page for "The Crete Boom"
	
