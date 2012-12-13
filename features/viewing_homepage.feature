Feature: View the homepage

	In order to make sure the app is loading
	As a visitor to 100 Motels
	I should see the homepage

	 Background:

   Given there are 4 organizers:
   And there are 3 events:
   And I visit the homepage


	Scenario: Homepage should have App name
		Then I should see "100 Motels"

  @javascript
	Scenario: Homepage should display some events
		Then the events should be listed
  @javascript
	Scenario: Homepage should display some organizers
		Then the organizers should be listed
    Then grab the page

