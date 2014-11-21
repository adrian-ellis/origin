@ready
Feature: Remove From Shortlist
  As a customer
  I would like to remove products from the shortlist
  So that I can make decisions about which products that I may not want to buy.

  Scenario Outline: Remove single product item from the Maybe column in My Shortlist
    Given I am using the "<country>" website
    And I add 5 "<product_type>" with item codes "<product_item_code_1>","<product_item_code_2>","<product_item_code_3>","<product_item_code_4>" and "<product_item_code_5>" to the Shortlist
    And I select View All Items In Detail
    And the items "<product_item_code_1>","<product_item_code_2>","<product_item_code_3>","<product_item_code_4>" and "<product_item_code_5>" are displayed in the Shortlist 'Maybe' column
    When I select Remove From Shortlist in the Shortlist 'Maybe Column' for item "<product_item_code_3>"
    Then only the item "<product_item_code_3>" is removed from the Maybe Column
    And the item "<product_item_code_3>" is added to the No Column

  Scenarios:
    |   country    | product_type   | product_item_code_1 | product_item_code_2 | product_item_code_3 | product_item_code_4 | product_item_code_5 |
    |      GB      | formal shirts  |      SN112SKY       |    FT095SKY         |     SP026BLU        |    ST109SKY         |     FA002WHT        |
    |      US      | formal shirts  |      SN112SKY       |    FT095SKY         |     SP026BLU        |    ST109SKY         |     FA002WHT        |
    |      AU      | formal shirts  |      SN112SKY       |    FT095SKY         |     SP026BLU        |    ST109SKY         |     FA002WHT        |
    |      DE      | formal shirts  |      SN112SKY       |    FT095SKY         |     SP026BLU        |    ST109SKY         |     FA002WHT        |

  @debug
  Scenario Outline: Remove all product items from the No column in My Shortlist
    Given I am using the "<country>" website
    And I add 5 "<product_type>" with item codes "<product_item_code_1>","<product_item_code_2>","<product_item_code_3>","<product_item_code_4>" and "<product_item_code_5>" to the Shortlist
    And the items "<product_item_code_1>","<product_item_code_2>","<product_item_code_3>","<product_item_code_4>" and "<product_item_code_5>" are displayed in the Shortlist 'No' column
    When I select Remove All from the No Column
    Then the items "<product_item_code_1>","<product_item_code_2>","<product_item_code_3>","<product_item_code_4>" and "<product_item_code_5>" are removed from the No Column

  Scenarios:
    |   country    | product_type   | product_item_code_1 | product_item_code_2 | product_item_code_3 | product_item_code_4 | product_item_code_5 |
    |      GB      | formal shirts  |      SN112SKY       |    FT095SKY         |     SP026BLU        |    ST109SKY         |     FA002WHT        |
    |      US      | formal shirts  |      SN112SKY       |    FT095SKY         |     SP026BLU        |    ST109SKY         |     FA002WHT        |
    |      AU      | formal shirts  |      SN112SKY       |    FT095SKY         |     SP026BLU        |    ST109SKY         |     FA002WHT        |
    |      DE      | formal shirts  |      SN112SKY       |    FT095SKY         |     SP026BLU        |    ST109SKY         |     FA002WHT        |

