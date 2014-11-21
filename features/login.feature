@capybara
Feature: Login to account
  As a customer
  I would like to login
  So that I can login to my account

  Scenario Outline: Login is successful
    Given I am using the "<country>" website
    When I login with "<email_addr>" and "<password>"
    Then the login is successful
    And my home page is displayed
  Scenarios:
    | country |           email_addr     |     password   |
    | GB      |  adrian_ellis0@sky.com   |   laurel16     |

  Scenario Outline: Login fails due to invalid username or password
    Given I am using the "<country>" website
    When I login with "<email_addr>" and "<password>"
    Then the login fails
    And the error message "Sorry, there are some things you need to correct on the form Your email address or password are not recognised" is displayed
    And the login page is still displayed
  Scenarios:
    | country |           email_addr     |     password   |
    | GB      |  adrian_ellis0@sky.com   |   rel16        |