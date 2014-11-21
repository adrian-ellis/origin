@jobserve
Feature: Test Google Maps REST services
  As a client
  I would like to query the Google Maps REST services
  So that I can use any map based data from available from Google Maps for my own purposes

  Scenario: Send a Jobsearch POST request to the Jobserve REST service
    Given I send 50 'jobsearch_POST' requests to the Jobserve REST service
    Then I should receive a request was successful response code

  Scenario: Send a UpdatePolling GET request to the Jobserve REST service
    Given I send a 'UpdatePolling_GET' request to the Jobserve REST service
    Then I should receive a request was successful response code

