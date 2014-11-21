@google
Feature: Test Google Maps REST services
  As a client
  I would like to query the Google Maps REST services
  So that I can use any map based data from available from Google Maps for my own purposes

  Scenario Outline: Send a GET request to the Google Maps 'geocode' REST API specifying just address
    When I send a GET request to the geocode REST Service specifying '<search_address>' as an input parameter
    Then I should receive a request was successful response code
    And the response header contains valid data
    And the following data '<formatted_address>', '<route>', '<locality>', '<postal_town>', '<administrative_area>', '<country>', '<postal_code>' and '<location_type>' are contained in the response

  Examples:
    |            search_address               |     formatted_address    | route        |  locality | postal_town | administrative_area |     country    | postal_code |  location_type   |
    | north street, guildford, united kingdom | north street, guildford  | north street | guildford | guildford   |      surrey         | united kingdom |    GU1      |  GEOMETRIC_CENTER  |


  Scenario Outline: Send a GET request to the Google Maps 'geocode' REST API specifying address and post code
    When I send a GET request to the geocode REST Service specifying '<search_address>' and '<postcode>' as input parameters
    Then I should receive a request was successful response code
    And the response header contains valid data
    And the following data '<formatted_address>', '<route>', '<locality>', '<postal_town>', '<administrative_area>', '<country>', '<postal_code>' and '<location_type>' are contained in the response

  Examples:
    |            search_address               | postcode |    formatted_address    | route        |  locality | postal_town | administrative_area |     country    | postal_code |  location_type   |
    | north street, guildford, united kingdom |    GU1   | north street, guildford | north street | guildford | guildford   |      surrey         | united kingdom |    GU1      |  GEOMETRIC_CENTER  |
