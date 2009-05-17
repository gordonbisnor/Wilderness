Feature: View Category
	In order to view a category
	As a viewer
	I want to view a category 
 	
	Scenario: View Category
		Given I have 1 category
		And I am on the homepage
		When I follow "Surfing"
		Then I should see "Articles Categorized “Surfing”"
