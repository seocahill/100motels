Feature: Authentication
	In order to use the site
	As a user
	I want to be able to sign up and thereafter sign in

	Scenario: Signing up

		Given I am on the homepage
		When I click "Sign up"
		And I fill in "Email" with "seo@creteboom.com"
		And I fill in "Password" with "foobar"
		And I fill in "user_password_confirmation" with "foobar"
		And I press "Sign up"
		Then I should see "A message with a confirmation link has been sent to your email address."

	Scenario: Signing in via confirmation

		Given there are the following users:
		| email							| password | unconfirmed  |
		| seo@creteboom.com | foobar 	 | true					|
		And "seo@creteboom.com" opens the email with subject "Confirmation instructions"
		And they click the first link in the email
		Then I should see "Your account was successfully confirmed"
		And I should see "Signed in as seo@creteboom.com"

	Scenario: Signing in via form

			Given there are the following users:
			| email							| password | unconfirmed  |
			| seo@creteboom.com | foobar 	 | false  			|
			And I am on the homepage
			When I click "Sign in"
			And I fill in "Email" with "seo@creteboom.com"
			And I fill in "Password" with "foobar"
			And I press "Sign in"
			Then I should see "Signed in successfully."