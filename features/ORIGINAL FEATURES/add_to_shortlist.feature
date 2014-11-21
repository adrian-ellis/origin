@ready
Feature: Add To Shortlist
  As a customer
  I would like to add products to the shortlist
  So that I can make decisions about which products that I may want to buy.

  Scenario Outline: Verify Shortlist Minibar components are displayed when adding an item to the Shortlist
    Given I am using the "<country>" website
    And I am on the product item detail page for a "<product_type>" with item code "<product_item_code>"
    When I select Add To Shortlist
    Then the Shortlist Minibar is displayed underneath the product item detail page
    And the item "<product_item_code>" is added to the Shortlist
    And the correct thumbnail image for "<product_item_code>" is displayed in the Shortlist Minibar
    And the View All Items In Detail, My Shortlist header, Information text link, Minimise Shortlist and Close Shortlist controls are displayed in the Shortlist Minibar

  Scenarios:
    | country |  product_type   |   product_item_code  |
    |   GB    |  formal shirt   |       FT095SKY       |
    |   AU    |  formal shirt   |       FT095SKY       |

  @optional
  Scenario Outline: Add multiple product items to the Shortlist
    Given I am using the "<country>" website
    And I add 5 "<product_type>" with item codes "<product_item_code_1>","<product_item_code_2>","<product_item_code_3>","<product_item_code_4>" and "<product_item_code_5>" to the Shortlist
    Then the items "<product_item_code_1>","<product_item_code_2>","<product_item_code_3>","<product_item_code_4>" and "<product_item_code_5>" are added to the Shortlist Minibar
    And the correct thumbnail images for "<product_item_code_1>","<product_item_code_2>","<product_item_code_3>","<product_item_code_4>" and "<product_item_code_5>" are displayed in the Shortlist Minibar

  Scenarios:
    | country | product_type   | product_item_code_1 | product_item_code_2 | product_item_code_3 | product_item_code_4 | product_item_code_5 |
    |   GB    | formal shirts  |      FT095SKY       |    ST109SKY         |     SP026BLU        |    SN112SKY         |     FA002WHT        |
    |   AU    | formal shirts  |      FT095SKY       |    ST109SKY         |     SP026BLU        |    SN112SKY         |     FA002WHT        |

  @optional
  Scenario Outline: My Shortlist contains all the product items added to the Shortlist in the Maybe column
    Given I am using the "<country>" website
    And I add 5 "<product_type>" with item codes "<product_item_code_1>","<product_item_code_2>","<product_item_code_3>","<product_item_code_4>" and "<product_item_code_5>" to the Shortlist
    And the items "<product_item_code_1>","<product_item_code_2>","<product_item_code_3>","<product_item_code_4>" and "<product_item_code_5>" are added to the Shortlist Minibar
    When I select View All Items In Detail
    Then the My Shortlist page is displayed
    And the items "<product_item_code_1>","<product_item_code_2>","<product_item_code_3>","<product_item_code_4>" and "<product_item_code_5>" are displayed in the Shortlist 'Maybe' column

  Scenarios:
    | country | product_type   | product_item_code_1 | product_item_code_2 | product_item_code_3 | product_item_code_4 | product_item_code_5 |
    |   GB    | formal shirts  |      FT095SKY       |    ST109SKY         |     SP026BLU        |    SN112SKY         |     FA002WHT        |
    |   AU    | formal shirts  |      FT095SKY       |    ST109SKY         |     SP026BLU        |    SN112SKY         |     FA002WHT        |

