Feature: View the homepage

	In order to make sure the app is loading
	As a visitor to 100 Motels
	I should see the homepage

	 Background:

   Given there are 5 users:
   And there are 5 events:
   And I visit the homepage
	
	Scenario: Homepage should have App name
		
		Then I should see "100 Motels, A Place for Anarchy"

	Scenario: Homepage should list newest users only

		Then those users should be listed
		And I should not see "last@creteboom.com (User)"
	
	Scenario: Homepage should list latest events

		Then those events should be listed
		And I should not see "Hacker Allstars"
		
	