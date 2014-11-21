@ready
Feature: Match Tie and Cufflinks
  As a customer
  I would like to match a set of tie and cufflinks to a suitable formal shirt
  So that I can make a better decision about shirt, tie and cufflink items that I may want to buy.

  Scenario Outline: Verify that the "Match Tie and Cufflinks" lightbox appears
    Given I am using the "<country>" website
    Given I am on the product item detail page for formal shirt "<product_item_code>"
    When I select Match Tie and Cufflinks
    Then the Match Tie and Cufflinks lightbox appears
    And the Match Tie and Cufflinks lightbox contains a preview photo of the currently displayed Shirt, Tie and Cufflinks for "<product_item_code>"
    And the Match Tie and Cufflinks lightbox contains previous and next navigation buttons for both Ties and Cufflinks
    And the Match Tie and Cufflinks lightbox contains a Title, Description, Thumbnail Photo and Add To Basket link for the currently displayed Tie and Cufflinks

  Scenarios:
    |   country    | product_item_code |
    |      GB      |    FA002WHT       |
    |      US      |    FA002WHT       |
    |      AU      |    FA002WHT       |

  Scenario Outline: Match a set of Tie and Cufflinks to a formal shirt then add them to the Basket
    Given I am using the "<country>" website
    Given I am on the product item detail page for formal shirt "<product_item_code>"
    And I select Match Tie and Cufflinks
    When I select the "<product_1>" display "<direction_1>" navigation contol "<repetition_number_1>" number of times
    And I select the "<product_2>" display "<direction_2>" navigation contol "<repetition_number_2>" number of times
    And the "<product_1>" displayed shift "<repetition_number_1>" positions to the "<direction_1>"
    And the "<product_2>" displayed shift "<repetition_number_2>" positions to the "<direction_2>"
    And I select Add To Basket for both items
    Then the selected Tie and Cufflinks are both added to the Basket

  Scenarios:
    |   country    | product_item_code |  product_1 | direction_1 | repetition_number_1 |   product_2   | direction_2 | repetition_number_2 |
    |      GB      |     FA002WHT      |    tie     |    next     |         2           |   cufflinks   |  previous   |          5          |
    |      US      |     FA002WHT      |    tie     |    next     |         1           |   cufflinks   |  previous   |          2          |
    |      AU      |     FA002WHT      |    tie     |    next     |         5           |   cufflinks   |  previous   |          3          |


