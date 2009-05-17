Feature: View Archives
	In order to view archives
	As a viewer
	I want to view archives
	
	Scenario: View Article
		Given I have 1 article
		And I am on the list of articles
		When I follow "January 2009 (1)"
		Then I should see "Articles Posted January 2009"
		And I should see "Beach"