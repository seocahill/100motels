Feature: Viewing events
	In order to buy tickets to events
	As a fan
	I want to be able to see a list of all events

	Scenario:
		Given that there is an event for the Artist "Crete Boom"
		And I am on the Events index page
		When I click "Event Details"
		Then I should be on the event page for "Crete Boom"
		And I should see "Venue - Ballina"
		And I should see "Date - 21st of January 2012"
		And I should see "Ticket Price - €10"