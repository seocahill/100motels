Feature: Sign up
	In order to create events 
	As a user / promoter
	I want to be able to sign up

	Scenario: Signing up
		Given I am on the Events index page
		When I click "Sign up"
		And I fill in "Email" with "seo@creteboom.com"
		And I fill in "Password" with "foobar"
		And I fill in "Password confirmation" with "foobar"
		And I press "Sign up"
		Then I should see "You have signed up successfully"
