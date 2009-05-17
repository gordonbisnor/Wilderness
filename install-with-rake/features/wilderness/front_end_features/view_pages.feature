Feature: View Page
	In order to view a page
	As a viewer
	I want to view a page
 	
	Scenario: View Page
		Given I have 1 page
		And I am on the homepage
		When I follow "Safari"
		Then I should see "Safari"
