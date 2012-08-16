Feature: Events

	In order to buy tickets to events
	As a fan/user
	I want to be able to see a list of all events

	Background:

		Given the events:
      | Crete Boom       |
      | The Crete Boom   |
    
  Scenario: Events available
    When I visit the box office
    Then those events should be listed

	Scenario: Navigating to the show page

		Given I go to the events page
		When I click "Event Details"
		Then I should see the event page for "Crete Boom"
		