Feature: View The Dashboard
	In order to see a site overview
	As an administrator
	I want to see the dashboard 

	Scenario: View Dashboard
	Given the following user records
	 | login    | password | email 					  |
	 | admin    | secret   | admin@admin.com  |
	 | viewer    | viewer   | viewer@viewer.com  |
	And I am logged in as "admin" with password "secret"
	When I visit the dashboard
	Then I should see "Recent Activity"
