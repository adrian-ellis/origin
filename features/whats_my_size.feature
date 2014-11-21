@ready
Feature: View "What's my size" details for a given product type
  As a customer 
  I would like to view the fitting measurements for a type of clothing
  So that I can choose the measurements that best suit my needs for clothing items I may want to buy

  Scenario Outline: verify "What's My Size" contains the correct type of information for the product type
    Given I am using the "<country>" website
    And I am on the product item detail page for the product item "<product_item_code>" which belongs to "<product_type>"
    When I select Whats My Size on the product item detail page for "<product_item_code>"
    Then the "<product_type>" Whats My Size lightbox is displayed
    And the "<product_type>" Whats My Size lightbox contains the measurements suitable for "<product_type>"

  Scenarios:
    | country  |   product_type                     |  product_item_code |
    |   GB     |   slim fit shirts                  |     FA002WHT       |
    |   GB     |  Extra Slim Fit Shirts             |     FZ049BLK       |

  Scenario Outline: verify I can see the "What's My Size" details in units of centimeters or inches
    Given I am using the "<country>" website
    And I am on the product item detail page for the product item "<product_item_code>" which belongs to "<product_type>"
    And the "<product_type>" Whats My Size lightbox displayed contains measurements in "<initial_units>"
    When I select View In "<desired_units>"
    Then the measurements in the Whats My Size lightbox are converted to "<desired_units>"

  Scenarios:
    | country  |   product_type                     |  product_item_code |  initial_units  | desired_units  |
    |   GB     |   slim fit shirts                  |     FA002WHT       |     inches      |      cm        |
    |   GB     |  Extra Slim Fit Shirts             |     FZ049BLK       |     inches      |      cm        |
    |   GB     |   slim fit shirts                  |     FA002WHT       |      cm         |    inches      |
    |   GB     |  Extra Slim Fit Shirts             |     FZ049BLK       |      cm         |    inches      |


