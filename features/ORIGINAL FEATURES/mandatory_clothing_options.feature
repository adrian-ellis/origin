@ready
Feature: Mandatory selection of clothing measurements/options
  As a customer
  I need to select any clothing measurements/options that are mandatory
  So that ctshirts has all the necessary measuremments needed to make up that clothing item that I may want to buy.

  Scenario Outline: Cannot Add to basket when Mandatory clothing measurement/option is missing
    Given I am using the "<country>" website
    And I am on the "<product_type>" item detail page for "<product_item_code>"
    And the "<mandatory_measurement_1>" selection box contains the text please select
    When I select Add To basket
    Then the "<mandatory_measurement_1>" selection box contains the text please select and is highlighted in red
    And the "<mandatory_measurement_2>" selection box contains the text please select and is highlighted in red
    And the clothing item is not added to my basket

  Scenarios:
    | country |  product_type   | product_item_code |  mandatory_measurement_1   |  mandatory_measurement_2   |
    |   GB    |  casual shirt   |     CW244WHT      |      size                  |                            |
    |   AU    |  casual shirt   |     CW244WHT      |      size                  |                            |
    |   US    |  casual shirt   |     CW244WHT      |      size                  |                            |
    |   DE    |  casual shirt   |     CW244WHT      |      size                  |                            |
    |   GB    |  formal shirt   |     SN112SKY      |      sleeve length         |      collar size           |
    |   AU    |  formal shirt   |     SN112SKY      |      sleeve length         |      collar size           |
    |   US    |  formal shirt   |     SN112SKY      |      sleeve length         |      collar size           |
    |   DE    |  formal shirt   |     ST109SKY      |      sleeve length         |      collar size           |

  Scenario Outline: Can Add to basket when Mandatory clothing measurement/option is given
    Given I am using the "<country>" website
    And I am on the "<product_type>" item detail page for "<product_item_code>"
    And the "<mandatory_measurement_1>" selection box already contains the text please select and is highlighted in red
    And the "<mandatory_measurement_2>" selection box already contains the text please select and is highlighted in red
    And I select a value from "<mandatory_measurement_1>"
    And I select a value from "<mandatory_measurement_2>"
    When I select Add To basket
    Then the clothing item is added to my basket

  Scenarios:
    | country |  product_type   | product_item_code |  mandatory_measurement_1   |  mandatory_measurement_2   |
    |   GB    |  formal shirt   |     ST109SKY      |      sleeve length         |                            |
    |   GB    |  casual shirt   |     CK049GRN      |      size                  |                            |


