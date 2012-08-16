Feature: Managing events

	In order to sell tickets
	As a an admin/promoter
	I want to create and manage events easily

	Background:

		Given there are the following users:
		| email								| password   | admin |
		| admin@creteboom.com |	foobar		 | true  |
		And I am signed in as them
		Given that there is an event for the Artist "The Crete Boom"
		And I am on the events page

	Scenario: Creating an event with valid information

		When I click "New Event"
		And I create an event with valid input
		Then I should see "Rock and Roll"
		And I should see "Crete Boom - Events - 100 Motels"

	Scenario: Updating an Event

		When I click "Event Details"
		And I click "Edit Event"
		And I fill in "Artist" with "The New Crete Boom"
		And I press "Update Event"
		Then I should see "Event has been updated"
		And I should see "The New Crete Boom"

	Scenario: Deleting an event

		When I click "Event Details"
		And I click "Delete Event"
		Then I should see "Event has been deleted"
		Then I should not see "The Crete Boom"
