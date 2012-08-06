Feature: Sign up
	In order to create events 
	As a user / promoter
	I want to be able to sign up

	Scenario: Signing up
		Given I am on the homepage
		And I follow "sign up"
		And I fill in "email" with "seo@creteboom.com"
		And I fill in "password" with "foobar"
		And I fill in "password confirmation" with "foobar"
		And I press "Sign up"
		Then I should see "You have signed up successfully"
