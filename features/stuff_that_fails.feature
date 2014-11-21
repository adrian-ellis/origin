Feature: Add To Shortlist
  As a customer
  I would like to add products to the shortlist
  So that I can make decisions about which products that I may want to buy.

  @debug
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
  @au
  Scenarios:
    | country |  product_type   |   product_item_code  |
    |   AU    |  formal shirt   |       FT095SKY       |


  Scenario Outline: Add multiple product items to the Shortlist
    Given I am using the "<country>" website
    And I add 5 "<product_type>" with item codes "<product_item_code_1>","<product_item_code_2>","<product_item_code_3>","<product_item_code_4>" and "<product_item_code_5>" to the Shortlist
    Then the items "<product_item_code_1>","<product_item_code_2>","<product_item_code_3>","<product_item_code_4>" and "<product_item_code_5>" are added to the Shortlist Minibar
    And the correct thumbnail images for "<product_item_code_1>","<product_item_code_2>","<product_item_code_3>","<product_item_code_4>" and "<product_item_code_5>" are displayed in the Shortlist Minibar

  Scenarios:
    | country | product_type   | product_item_code_1 | product_item_code_2 | product_item_code_3 | product_item_code_4 | product_item_code_5 |
    |   GB    | formal shirts  |      FT095SKY       |    ST109SKY         |     SP026BLU        |    SN112SKY         |     FA002WHT        |
  @au
  Scenarios:
    | country | product_type   | product_item_code_1 | product_item_code_2 | product_item_code_3 | product_item_code_4 | product_item_code_5 |
    |   AU    | formal shirts  |      FT095SKY       |    ST109SKY         |     SP026BLU        |    SN112SKY         |     FA002WHT        |


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
  @au
  Scenarios:
    | country | product_type   | product_item_code_1 | product_item_code_2 | product_item_code_3 | product_item_code_4 | product_item_code_5 |
    |   GB    | formal shirts  |      FT095SKY       |    ST109SKY         |     SP026BLU        |    SN112SKY         |     FA002WHT        |



  @debugxxxx
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

  @debugxxxx
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

