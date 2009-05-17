Feature: Do Search
	In order to search
	As a viewer
	I want to search for something

	Scenario: Do Search
		Given I have 1 article          
		And I am on the list of articles
		And I fill in "value" with "Beach"
		And I press "Find"
		Then I should see "Search Results For “Beach”"
		And I should see "Beach"
