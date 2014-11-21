@ready
Feature: Select any casual shirt from the casual shirt product page by filtering on the category 'size'
  As a customer
  I would like to be able to view any casual shirt product item detail page
  So that I can view any casual shirt clothing items that I may want to buy.

  Background:

  Scenario Outline: View any of the men's casual shirts detail pages
    Given I am using the "<country>" website
    And I am on the product page for men's casual shirts
    And I enable the filter for the category "<size>"
    And I select View All
    And all of the men's casual shirt items available in the category "<size>" are displayed the on casual shirt product page
    When I select the casual shirt product item "<product_item_code>" from the casual shirt product page
    Then the product item detail page for the casual shirt "<product_item_code>" is displayed

  Examples:
    | country  | size |   product_item_code     |
	|    GB    |  S   |      CW244WHT           |
	|    GB    |  S   |      CK049GRN           |
	|    GB    |  S   |      CZ096RED           |