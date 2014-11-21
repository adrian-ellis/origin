Feature: Verify that a customer can purchase items and complete the checkout process
  As a customer
  I would like to add items to my basket and then place an order on the ctshirts website
  So that I can purchase any items listed on the ctshirts website

  Scenario Outline: Add shirt product items to my basket and generate a new order
    Given I log in to my account with "<email_address>" and "<password>" in country "<country_code>"
    And I place items "<qty_1>" of "<product_item_code_1>", "<qty_2>" of "<product_item_code_2>" and "<qty_3>" of "<product_item_code_3>" in my basket
    When I place an order
    Then the order is confirmed
    And the payment amount is correct

  Scenarios:
    |country_code |        email_address             |  password   | qty_1 |product_item_code_1 |qty_2 |product_item_code_2 |qty_3 | product_item_code_3 |
    |   GB        |   adrian_ellis@btopenworld.com   |  testing123 |  2    |      CW244WHT      |  1   |      CD074SKY      |  3   |      CK049GRN       |
    |   US        |   adrian_ellis@btopenworld.com   |  testing123 |  2    |      CW244WHT      |  1   |      CD074SKY      |  3   |      CK049GRN       |
    |   AU        |   adrian_ellis@btopenworld.com   |  testing123 |  2    |      CW244WHT      |  1   |      CD074SKY      |  3   |      CK049GRN       |
    |   DE        |   adrian_ellis@btopenworld.com   |  testing123 |  2    |      CW244WHT      |  1   |      CD074SKY      |  3   |      CK049GRN       |
