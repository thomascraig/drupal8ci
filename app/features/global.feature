Feature: Test Features
	Some test scenarios to make sure the website is generally working.

@api
  Scenario: Run cron
    Given I am logged in as a user with the "administrator" role
    When I run cron
    And am on "admin/reports/dblog"
    Then I should see the link "Cron run completed"