Feature: View and Post Comments
	In order to view and post comments
	As a viewer
	I want to view and post comments
		
	Scenario: View Comments
		Given I have 1 article
		And I have 1 comment 
		And I am on the list of articles
		When I follow "Beach"
    Then I should see "Beach"
		And I should see "(1 comment)"
		And I should see "My Comment"
		And I should see "Great article!" 
		And I should see "Rick Danger"

	Scenario: Create Valid Comment
 		Given I have no comments
		And I have 1 article
		And I am on the list of articles
		When I follow "Beach"
		And I fill in "comment_title" with "Great stuff"
		And I fill in "comment_content" with "Total enjoyment"
		And I fill in "comment_author" with "Wilderness Joe"
		And I fill in "comment_author_email" with "wilderness@gmail.com"
		And I fill in "comment_author_url" with "http://www.wilderness.com"
		And I press "Create"
		Then I should see "Comment created"
		And I should see "Great stuff"
		And I should see "Total enjoyment"
		And I should see "Wilderness Joe"
		And I should have 1 comment          
		
		# HOW TO TEST SPAM WITHOUT SPECING A KEY AS A CONSTANT IN THE INIT SINCE TEST DB DOES NOT MIGRATE RECORDS