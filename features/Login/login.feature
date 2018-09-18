@login_page
Feature: Login page test
  
  Scenario: Login
    Given I visit the login page
    When I login with correct credentials
    Then I am logged into the secure area