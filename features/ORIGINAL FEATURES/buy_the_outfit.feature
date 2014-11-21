@ready
Feature: Buy the outfit
  As a customer
  I would like to view clothing items as an outfit
  So that I can make a better decision about a set of clothing items that I may want to buy.

  Scenario Outline: Select an outfit from the Buy The Outfit carousel
    Given I am on the Buy The Outfit page
    When I select "<outfit_type>" from the Buy The Outfit carousel
    Then the "<outfit_type>" page is displayed 
    And it contains all the components for the "<outfit_type>" 
    And each component has a carousel upon which the alternative components are displayed

  Scenarios:
        |        outfit_type        |
        |  formal modern look       |


  Scenario: Verify previews of all outfits are displayed on the "Buy the outfit" main page
    Given I am on the ctshirts home page
    And the Buy The Outfit link is displayed under the Style Hints Tips heading
    When I select Buy The Outfit
    Then the Buy The Outfit page is displayed
    And it contains a carousel upon which the outfits are displayed
      |         outfit_type          |
      |  classic formal look         |
      |  ultimate smart look         |
      |  business casual look        |
      |  contemporary formal look    |
      |  the essential weekend look  |
      |  business casual with tweed  |
      |  smart business casual look  |
      |  trendy business casual      |
      |  traditional formal look     |


  Scenario Outline: Cannot add outfit component "Jacket" to basket when Mandatory clothing measurement/option is missing
    Given I am on the "<outfit_type>" page
    When I select Add To Basket next to the currently displayed jacket
    And the "<mandatory_measurement_1>" selection box is displayed and contains the text Please Select and is highlighted in red
    And the "<mandatory_measurement_2>" selection box is displayed and contains the text Please Select and is highlighted in red
    And I am unable to add this jacket to my basket

  Scenarios:
        |        outfit_type        |    mandatory_measurement_1   |   mandatory_measurement_2   |
        |  formal modern look       |      jacket chest size       |         sleeve length       |


  Scenario Outline: Can add outfit component to basket
    Given I am on the "<outfit_type>" page
    And the currently displayed "<outfit_component>" is selected
    And the "<mandatory_measurement_1>" selection box is displayed and contains the text Please Select and is highlighted in red
    And the "<mandatory_measurement_2>" selection box is displayed and contains the text Please Select and is highlighted in red
    When I select a value from the "<mandatory_measurement_1>" selection box
    And I select a value from the "<mandatory_measurement_2>" selection box     
    And I select Add To Basket
    Then the "<outfit_component>" clothing item is added to my basket

  Scenarios:
	|      outfit_type          | outfit_component  |  mandatory_measurement_1   |  mandatory_measurement_2   |
	|  formal modern look       |     jacket        |       sleeve length        |     jacket chest size      |





