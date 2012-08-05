Feature: Editing Events
	In order to update the event information
	As a user
	I want to be able to do that through a view

	Scenario: Updating an Event
		Given there is an event called "Crete Boom"
		And I am on the events index page
		When I follow "Crete Boom"
		And I follow "Edit Project"
		And I fill in "Artist" with "The Crete Boom"
		And I press "Update Project"
		Then I should see "Event has been updated."
		Then I should be on the event page for "The Crete Boom"
	
