
Feature: As a customer
  As a customer
  I want to be notified when I fail to select a mandatory option for an item I wish to purchase
  So that I can complete the ordering process more efficiently

  Scenario Outline: Attempt to add an item to my basket without selecting a mandatory option
    Given I am using the "<country>" website
    And I do not select the mandatory option "<option>" for a "<item_type>"
    When I select add to basket
    Then the text "please select" is displayed in red
    And the item is not added to my basket

  Examples:
    | country |   item_type  |    option      |
    | DE      | formal shirt | sleeve length  |
    | AU      | formal shirt | sleeve length  |
    | US      | formal shirt | sleeve length  |
    | GB      | formal shirt | sleeve length  |
    | DE      | casual shirt |     size       |
    | AU      | casual shirt |     size       |
    | US      | casual shirt |     size       |
    | GB      | casual shirt |     size       |

  @mand_opt_1
  Scenario Outline: Attempt to add an item to my basket after dealing with the mandatory option warning
    Given I am using the "<country>" website
    And the text "please select" is displayed in red for mandatory option "<option>" for the "<item_type>"
    When I select the mandatory option "<option>" for the "<item_type>" item
    And I select add to basket
    Then the item is added to my basket

  Examples:
    | country |   item_type  |    option      |
    | DE      | formal shirt | sleeve length  |
    | AU      | formal shirt | sleeve length  |
