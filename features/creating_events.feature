Feature: Creating events
	In order to have events to sell tickets for 
	As a logged in user
	I want to create them easily

	Background:
		Given there are the following users:
		| email								| password   | admin |
		| admin@creteboom.com |	foobar		 | true  |
		And I am signed in as them
		Given I am on the Events index page
		When I follow "New Event"

	Scenario: Creating an event with valid information
		And I create an event with valid input
		Then I should see "Rock and Roll"
		And I should see "Crete Boom - Events - 100 Motels"

	Scenario: Creating an event without a name
		And I press "Create Event"
		Then I should see "Event has not been created"
		And I should see "Artist can't be blank"