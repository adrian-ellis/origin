Feature: Verify that the  'Monetate' tags are present on each ctshirts webpage
  As a vendor
  I would like to use the 'Monetate' tagging facility on each ctshirts webpage
  So that I can use the data generated to improve the collection of statistics from our customers

  @monetate
  Scenario Outline: 'Monetate' Tags are present on the Home page
    Given I navigate to the Home page in country "<country_code>"
    Then the Monetate tags are present

  Scenarios:
    | country_code  |
    |      GB       |
    |      US       |
    |      AU       |
    |      DE       |
