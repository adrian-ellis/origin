Feature: Improved category filtering for clothing items displayed on a product page
  As a customer
  I would like to use the category filtesr to select the items displayed on a product page
  So that I can view only the clothing items that I may want to buy

  Scenario Outline: Select category filters on Men's shirts product page
    Given I select View All Men's Shirts from the Main Menu bar
    And I select category filters "<value_1>" from "<category_1>", "<value_2>" from "<category_2>", and "<value_3>" from "<category_3>"
    Then the product items displayed belong only to "<value_1>" from "<category_1>", "<value_2>" from "<category_3>", and "<value_3> from "<category_3>"
    And horizontal confirmation boxes for "<value_1>", "<value_2>" and "<value_3>" are displayed on the same row
    And the product items are ordered by "<value_1>", "<value_2>" and "<value_3>"

  Scenarios:
    |  category_1             |  value_1               |     category_2      |   value_2    |   category_3          |   value_3      |
    | Formal or casual shirt? |  View All              |    Multibuys        |  2 for £80   |      Multibuys        |    4 for £100  |
    | Formal or casual shirt? |  View All              |    Multibuys        |  2 for £80   |    Formal Collar Size |   15.5         |
    | Formal or casual shirt? | Slim fit casual shirts |     Multibuys       |  4 for £100  |    Shirt Size         |   Medium       |
    |  What's your fit?       |  Classic fit           |     Multibuys       |  4 for £100  |    Shirt Colour       |   Blue         |
    |   What's your fit?      |    Slim fit            |  Formal Collar Size |     17.5     |    Price range        |   £25 - 29.99  |

  Scenario: Select more than 5 category filters on Men's shirts product page
    Given I am on the men's shirts product page
    And I select more than 5 category filters
    Then the product items displayed belong only to those 5 categories
    And the first 5 horizontal confirmation boxes are displayed on the same row
    And the remaining horizontal confirmation boxes are displayed on the next row

  Scenario Outline: Deselect a category filter on Men's shirts product page
    Given I am on the men's shirts product page
    And I select category filters "<value_1>" from "<category_1>", "<value_2>" from "<category_2>", and "<value_3>" from "<category_3>"
    When I deselect the horizontal confirmation box "<value_1>"
    Then category filter "<value_1>" from "<category_1>" is deselected
    Then the product items displayed belong to "<value_2>" from "<category_3>" and "<value_3> from "<category_3>"
    And the product items are ordered by "<value_2>" and "<value_3>"

  Scenarios:
    |  category_1   |  value_1   |     category_2      |   value_2    |   category_3     |   value_3      |
    |  Mens Shirts  |  Formal    |     Multibuys       |  2 for £80   |    Shirt Size    |   Medium       |
    |  Mens Shirts  |  Formal    |     Multibuys       |  4 for £100  |    Shirt Colour  |   Blue         |
    |  Mens Shirts  |  Formal    |  Formal Collar Size |     15.5     |    Price range   |   £25 - 29.99  |

  Scenario: Display the Collar Type lightbox on Men's shirts product page
    Given I am on the men's shirts product page
    When I hover the mouse over the question mark icon next to the Collar Type heading
    Then the Collar Type lightbox is displayed

  Scenario: Close the Collar Type lightbox on Men's shirts product page
    Given the Collar Type lightbox is displayed
    When I select close
    Then the Collar Type lightbox is not displayed

  Scenario: Display the Cuff Type lightbox on Men's shirts product page
    Given I am on the men's shirts product page
    When I hover the mouse over the question mark icon next to the Cuff Type heading
    Then the Cuff Type lightbox is displayed

  Scenario: Close the Cuff Type lightbox on Men's shirts product page
    Given the Collar Type lightbox is displayed
    When I select close
    Then the Collar Type lightbox is not displayed

  Scenario: Display the Range lightbox on Men's shirts product page
    Given I am on the men's shirts product page
    When I hover the mouse over the question mark icon next to the Range heading
    Then the Range lightbox is displayed

  Scenario: Close the Range lightbox on Men's shirts product page
    Given the Collar Type lightbox is displayed
    When I select close
    Then the Collar Type lightbox is not displayed

  Scenario: Display the Fit lightbox on Men's shirts product page
    Given I am on the men's shirts product page
    When I hover the mouse over the question mark icon next to the Fit heading
    Then the Fit lightbox is displayed

  Scenario: Close the Fit lightbox on Men's shirts product page
    Given the Collar Type lightbox is displayed
    When I select close
    Then the Collar Type lightbox is not displayed

