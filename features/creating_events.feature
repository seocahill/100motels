Feature: Creating events
	In order to have events to sell tickets for 
	As a user
	I want to create them easily

	Scenario: Creating an event
		Given I am on homepage
		When I follow "New Event"
		And I fill in "Artist" with "Crete Boom"
		And I press "Create Event"
		Then I should see "Event has been created."