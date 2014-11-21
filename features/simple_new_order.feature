@simple_order
Feature: Create simple orders
  As a customer
  I would like to use this website to order fashion products
  So that I can purchase any fashion products I want online

  @debug
  Scenario: Very simple order successful
    Given I am logged into my account
    And I create an order
    Then my order is confirmed as being shipped

  @debug
  Scenario: Order for 1 product successful
    Given I am logged into my account as "user"
    And I create an order for "product"
    When I pay for the order by "payment_method"
    Then my order is confirmed as being shipped

  Scenario: Order for multiple products successful
    Given I am logged into my account as "adrian_ellis"
    And I create an order for:
      | quantity |  product    |
      |     50    |   CX5467RL  |
      |     50    |   SN7496UC  |
    When I pay for the order by "credit card"
    Then my order is confirmed as being shipped



