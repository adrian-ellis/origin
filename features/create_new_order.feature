@ready
Feature: Verify that a new order can be created
  As a customer
  I would like to create a new order
  So that I can purchase any products I desire from the ctshirts website


  Scenario Outline:  Create a new order for a given quantity of casual shirts
    Given I log in to my account with "<email_address>" and "<password>" in country "<country>"
    When I add "<qty_1>" of "<product_item_code_1>", "<qty_2>" of "<product_item_code_2>" and "<qty_3>" of "<product_item_code_3>" items to my basket
    And I go through the checkout process
    Then the order details for "<qty_1>" of "<product_item_code_1>", "<qty_2>" of "<product_item_code_2>" and "<qty_3>" of "<product_item_code_3>" are confirmed
    And the subtotal, delivery and total amounts are correct

  Scenarios:
    | country |        email_address             |  password   | qty_1 |product_item_code_1 |qty_2 |product_item_code_2 |qty_3 | product_item_code_3 |
    |   GB    |   adrian_ellis@btopenworld.com   |  testing123 |  2    |      CW244WHT      |  1   |      CD074SKY      |  3   |      CK049GRN       |
    |   US    |   adrian_ellis@btopenworld.com   |  testing123 |  1    |      CW244WHT      |  4   |      CD074SKY      |  2   |      CK049GRN       |
    |   AU    |   adrian_ellis@btopenworld.com   |  testing123 |  3    |      CW244WHT      |  1   |      CD074SKY      |  5   |      CK049GRN       |

  @better_idea
  Scenario: ** WORKFLOW LEVEL ** Create a new order for a given quantity of shirts
    Given I am logged into my account
    When I add these items to my basket:
     | qty | product_item_code |
     | 2   | CW244WHT          |
     | 1   | CD074SKY          |
     | 3   | CK049GRN          |
    And I go through the checkout process
    Then the order details are confirmed
    And the subtotal, delivery and total amounts are correct

  @another_better_idea
  Scenario: ** WORKFLOW SUMMARY LEVEL ** Create a new order for a given quantity of shirts
    Given I create an order for:
      | qty | product_item_code |
      | 2   | CW244WHT          |
      | 1   | CD074SKY          |
      | 3   | CK049GRN          |
    Then the subtotal, delivery and total amounts for this order are correct


  @country_specific_idea
  Scenario Outline: Create a new order on each of the country websites (GB,US,AU) for a given quantity of shirts
    Given I create an order on the '<country>' website for:
      | qty | product_item_code |
      | 2   | CW244WHT          |
      | 1   | CD074SKY          |
      | 3   | CK049GRN          |
    Then the subtotal, delivery and total amounts for this order are correct
  Scenarios:
    | country |
    |   GB    |
    |   US    |
    |   AU    |
