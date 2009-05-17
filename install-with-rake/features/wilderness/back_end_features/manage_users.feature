Feature: Manage Users
	In order to manage users details
	As an administrator
	I want to edit users only when authorized

	Scenario: View Users Index Page
	Given I am logged in as admin
	When I visit the users index page
	Then I should see "viewer"
	And I should see "admin"

	Scenario: View Users Detail Page
	Given I am logged in as admin
	When I visit user "viewer"
	Then I should see "viewer"
	And I should see "viewer@viewer.com"
	And I should see "Edit"
	And I should see "Delete"

	Scenario: Delete User
	Given I am logged in as admin
  When I visit user "viewer"
  And I follow "Delete"
  Then I should see "User Deleted"

  Scenario: Edit User
	Given I am logged in as admin
	When I visit user "viewer"
	Then I should see "viewer"
	