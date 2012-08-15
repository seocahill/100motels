Feature: Events

	In order to buy tickets to events
	As a fan
	I want to be able to see a list of all events

  Scenario: Events available

    Given the events:
      | Crete Boom       |
      | The Crete Boom   |
    When I visit the box office
    Then those events should be listed

	Scenario: Navigating to the show page

		Given that there is an event for the Artist "Crete Boom"
		And I am on the Events index page
		When I click "Event Details"
		Then I should be on the event page for "Crete Boom"
		