Feature: View Articles
	In order to view articles
	As a viewer
	I want to view articles
	
	Scenario: Articles List
		Given I have articles titled Beach, Fun
		And I am on the list of articles
		Then I should see "Beach"
		And I should see "Fun"
	
	Scenario: View Article
		Given I have 1 article
		And I am on the list of articles
		When I follow "Beach"
		Then I should see "Beach"
		