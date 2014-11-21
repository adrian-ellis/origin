
Feature: Change number of clothing items in my basket
  As a customer
  I would like change the number of items in my basket
  So that I can change my mind about clothing items that I intend to buy.

  @fries
  Scenario Outline: Change the quantity of shirts items in my basket to trigger the 'fries' shirts offer
    Given I am using the "<country>" website
    And I have the clothing items "<product_item_code_1>", "<product_item_code_2>" and "<product_item_code_3>" in my basket
    And I am at the Basket page
    When I alter the quantity for clothing item "<product_item_code_2>" from "<quantity>" to "<updated_quantity>"
    Then the quantity for the clothing item "<product_item_code_2>" in my basket is updated to "<updated_quantity>"
	And the subtotal and grand total are updated to reflect this change
    And the offer to buy a fifth shirt for "<Amount>" appears in a lightbox
    And there is a link to view the shirts available in the lightbox
	
  Scenarios:
    | country |  product_item_code_1     | quantity   | updated_quantity     |  product_item_code_2       | product_item_code_3   |  Amount |
    |   GB    |  CW244WHT                |     1      |         2            |  CK049GRN                  |  CZ096RED             |   25    |
    |   AU    |  CW244WHT                |     1      |         2            |  CK049GRN                  |  CZ096RED             |   199   |
    |   US    |  CW244WHT                |     1      |         2            |  CK049GRN                  |  CZ096RED             |   199   |
    |   DE    |  CW244WHT                |     1      |         2            |  CK049GRN                  |  CZ096RED             |   139   |

  @ready
  Scenario Outline: Change the quantity of one of the clothing items in my basket
    Given I am using the "<country>" website
    And I have the clothing items "<product_item_code_1>", "<product_item_code_2>" and "<product_item_code_3>" in my basket
    And I am at the Basket page
    When I alter the quantity for clothing item "<product_item_code_2>" from "<quantity>" to "<updated_quantity>"
    Then the quantity for the clothing item "<product_item_code_2>" in my basket is updated to "<updated_quantity>"
    And the subtotal and grand total are updated to reflect this change

  Scenarios:
    | country |  product_item_code_1     | quantity   | updated_quantity     |  product_item_code_2       | product_item_code_3   |
    |   GB    |  CW244WHT                |     1      |         2            |  CK049GRN                  |                       |
    |   AU    |  CW244WHT                |     1      |         2            |  CK049GRN                  |                       |
    |   US    |  CW244WHT                |     1      |         2            |  CK049GRN                  |                       |
    |   DE    |  CW244WHT                |     1      |         2            |  CK049GRN                  |                       |
