Feature: Creating events
	In order to have events to sell tickets for 
	As a logged in user
	I want to create them easily

	Scenario: Creating an event
		Given I am on the events index page
		When I follow "New Event"
		And I fill in "Artist" with "Crete Boom"
		And I press "Create Event"
		Then I should see "Rock and Roll"
		And I should see "Crete Boom - Events - 100 Motels"