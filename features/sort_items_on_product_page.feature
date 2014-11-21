@ready
Feature: Sort clothing items displayed on a product page by using a selected parameter
  As a customer
  I would like to use the sort facility to order the items on a product page
  So that I can view the clothing items that I may want to buy into a particular order

  Scenario Outline: Sort clothing items by a selected parameter
    Given I am using the "<country>" website
    And I am on the men's casual shirts product page
    When I sort the clothing items on the this page by the parameter "<sorting parameter>"
    Then the product items are displayed on the "<product page>" page ordered by the parameter "<sorting parameter>"

  Scenarios:
    | country  | product page   | sorting parameter   |
    |    GB    | Casual shirts  |    Name (A-Z)       |
    |    GB    | Casual shirts  |    Name (Z-A)       |
    |    GB    | Casual shirts  |   Price (lowest)    |
    |    GB    | Casual shirts  |   Price (highest)   |
