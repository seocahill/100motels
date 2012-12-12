Feature: View the homepage

	In order to make sure the app is loading
	As a visitor to 100 Motels
	I should see the homepage

	 Background:

   Given there are 5 organizers:
   And there are 5 events:
   And I visit the homepage

	Scenario: Homepage should have App name

		Then I should see "100 Motels"

	Scenario: Homepage should display some events

		Then those users should be listed

	Scenario: Homepage should display some organizers

		Then those events should be listed


