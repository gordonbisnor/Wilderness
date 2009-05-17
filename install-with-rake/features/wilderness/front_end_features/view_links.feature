Feature: View Links
	In order to view links
	As a viewer
	I want to view links

	Scenario: View Links
		Given I have 1 link            
		And I am on the homepage
		Then I should see "Cool Link"
#		Then I should see "Articles Posted January 2009"
