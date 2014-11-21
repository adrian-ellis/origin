
Feature: Filter clothing items displayed on a product page by category
  As a customer
  I would like to use the filter by category checkboxes on a product page
  So that I can view just the clothing items that I may want to buy.

  @filter_categories @chrome
  Scenario Outline: Filter men's casual shirts by category
    Given I am using the "<country>" website
    And I am on the product page for men's "casual shirts"
    When I enable the "casual shirts" filters for a combination of the "<size>" and "<fit>" and "<colour>" and "<range>" category checkboxes
    Then only the filtered men's "casual shirts" items for these categories are displayed

  Scenarios:
    | country  | size | fit         | colour                |      range          |
    |    GB    | S    |             |                       |                     |

  @filter_categories @firefox
  Scenario Outline: Filter men's casual shirts by category
    Given I am using the "<country>" website
    And I am on the product page for men's "casual shirts"
    When I enable the "casual shirts" filters for a combination of the "<size>" and "<fit>" and "<colour>" and "<range>" category checkboxes
    Then only the filtered men's "casual shirts" items for these categories are displayed

  Scenarios:
    | country  | size | fit         | colour                |      range          |
    |    GB    | XXL    |             |                       |                     |



  @filter_categories @chromey
  Scenario Outline: Filter men's casual shirts by category
    Given I am using the "<country>" website
    And I am on the product page for men's "casual shirts"
    When I enable the "casual shirts" filters for a combination of the "<size>" and "<fit>" and "<colour>" and "<range>" category checkboxes
    Then only the filtered men's "casual shirts" items for these categories are displayed

  Scenarios:
    | country  | size | fit         | colour                |      range          |
    |    GB    | S    |             |                       |                     |
    |    GB    | XXL  | Slim fit    | Red shirts            |   Tartan checks     |
    |    GB    | M    | Classic fit | Multicoloured shirts  |                     |
    |    GB    | M    | Classic fit | Blue shirts           |   Oxford shirts     |

  @filter_categories @firefoxy
  Scenario Outline: Filter men's casual shirts by category
    Given I am using the "<country>" website
    And I am on the product page for men's "casual shirts"
    When I enable the "casual shirts" filters for a combination of the "<size>" and "<fit>" and "<colour>" and "<range>" category checkboxes
    Then only the filtered men's "casual shirts" items for these categories are displayed

  Scenarios:
    | country  | size | fit         | colour                |      range          |
    |    GB    | S    |             |                       |                     |
    |    GB    | XXL  | Slim fit    | Red shirts            |   Tartan checks     |
    |    GB    | M    | Classic fit | Multicoloured shirts  |                     |
    |    GB    | M    | Classic fit | Blue shirts           |   Oxford shirts     |

  Scenario Outline: Filter men's formal shirts by category
    Given I am using the "<country>" website
    And I am on the product page for men's "formal shirts"
    When I enable the "formal shirts" filters for a combination of the "<collar_size>" and "<fit>" and "<colour>" and "<sleeve_length>" category checkboxes
    Then only the filtered men's "formal shirts" items for these categories are displayed

  Scenarios:
    | country  | collar_size | fit            | colour       | sleeve_length  |
    |    GB    | 16          | Extra slim fit | Blue         |      34        |
    |    GB    | 15          | Slim fit       | Blue         |      35        |
    |    GB    | 14.5        | Slim fit       | Pink         |      33        |
    |    GB    | 16.5        | Slim fit       | Blue         |                |
    |    GB    | 17          | Extra slim fit | White        |                |
