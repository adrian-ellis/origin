
Feature: Move from My Shortlist to the Basket
  As a customer
  I would like to add products from the shortlist to the basket
  So that I can purchase products that I previously added to the shortlist.

  Scenario Outline: Move single product item from the 'Maybe' column to the 'Yes' column in My Shortlist
    Given I add 5 "<product_type>" with item codes "<product_item_code_1>","<product_item_code_2>","<product_item_code_3>","<product_item_code_4>" and "<product_item_code_5>" to the Shortlist
    And the items "<product_item_code_1>","<product_item_code_2>","<product_item_code_3>","<product_item_code_4>" and "<product_item_code_5>" are displayed in the Shortlist 'Maybe' column
    When I select Add To Basket for item "<product_item_code_3>" within the Shortlist 'Maybe' Column
    And I select the required Size Options
    Then the item "<product_item_code_3>" is added to the 'Yes' Column
    And the item "<product_item_code_3>" is added to the Basket

  Scenarios:
    | product_type   | product_item_code_1 | product_item_code_2 | product_item_code_3 | product_item_code_4 | product_item_code_5 |
    | formal shirts  |      FD079CRM       |    FP003SKY         |     FU065PNK        |    RR035BLU         |     SN267LLC        |
