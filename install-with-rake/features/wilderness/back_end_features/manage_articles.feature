Feature: Manage Articles
	In order to manage articles 
	As an administrator
	I want to view, create, edit, and delete articles 

	Scenario: View Articles Admin Index Page
	Given I am logged in as admin
	And I have articles titled Beach, Fun
	When I visit the admin list of articles
	Then I should see "Beach"       
	And I should see "Fun"

	Scenario: View Articles Admin Detail Page
	Given I am logged in as admin
	And I have 1 article
	And I am on the admin list of articles
	When I follow "Show"
	Then I should see "Beach"
	And I should see "Edit"
	And I should see "Delete"

  Scenario: Create Article
	Given I am logged in as admin
	When I visit the article creation page
	And I fill in "article_title" with "Sexual"
	And I fill in "article_content" with "Healing"
	And I press "Go"
	Then I should see "Sexual"
	And I should see "Healing"
	And I should see "Article Created"

  Scenario: Edit Article
	Given I am logged in as admin
	And I have 1 article
	And I am on the admin list of articles
	When I follow "Edit"
	And I fill in "article_title" with "Lake"
	And I press "Go"
	Then I should see "Lake"
	And I should see "Article Updated"

	Scenario: Delete Article
	Given I am logged in as admin  
	And I have 1 article
  When I visit article "Beach"
  And I follow "Delete"
  Then I should see "Article Deleted"
