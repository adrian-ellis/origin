@bbc
Feature: Test BBC iPlayer REST services
  As a client
  I would like to query the BBC iPlayer REST services
  So that I can use any data from available from BBC iPlayer for my own purposes

  Scenario: Send a RecentlyWatched GET request to the BBC iPlayer REST service
    Given I send a RecentlyWatched GET request to the BBC iPlayer REST service
    Then I should receive a request was successful response code
    And the response header contains valid data
    And the response contains the last few programs I watched on iPlayer
