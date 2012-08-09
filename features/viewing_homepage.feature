Feature: View the homepage
	In order to make sure the app is loading
	As a visitor to 100 Motels
	I should see the homepage

	Scenario: Homepage should have App name
		Given I am on the homepage
		Then I should see "100 Motels"