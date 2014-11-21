@ready
Feature: Remove clothing items from my basket
  As a customer
  I would like remove items from my basket
  So that I can change my mind about clothing items that I intend to buy.

  Scenario Outline: Remove clothing items from my basket
    Given I am using the "<country>" website
    And I have the clothing items "<product_item_code_1>", "<product_item_code_2>" and "<product_item_code_3>" in my basket
    And I am at the Basket page
    When I select Remove next to the clothing item "<product_item_code_3>"
    Then "<product_item_code_3>" is removed from my basket
    And the subtotal and grand total are updated to reflect the clothing item's removal

  Scenarios:
    | country |  product_item_code_1     |  product_item_code_2           | product_item_code_3   |
    |   GB    |  CD074SKY                |      CZ096RED                  |    CW244WHT           |
    |   AU    |  CD074SKY                |      CZ096RED                  |    CW244WHT           |
    |   US    |  CD074SKY                |      CZ096RED                  |    CW244WHT           |
    |   DE    |  CD074SKY                |      CZ096RED                  |    CW244WHT           |

