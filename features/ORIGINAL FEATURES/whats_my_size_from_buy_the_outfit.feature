Feature: View "What's My Size" details from a "Buy The Outfit" page
  As a customer 
  I would like to view the fitting measurements for a type of clothing when I'm on a 'buy the outfit' page
  So that I can choose the measurements that best suit my needs for clothing items I may want to buy

  Scenario Outline: verify "What's My Size" contains the correct type of information for the product type on the Buy The Outfit page
    Given I am on a Buy The Outfit page for the "<outfit_type>" outfit
    And the currently displayed outfit component is "<outfit_component>"
    When I select Whats My Size on the "<outfit_component>" part of the page
    Then the "<outfit_component>" Whats My Size lightbox appears
    And the "<outfit_component>" Whats My Size lightbox contains the measurements suitable for "<outfit_component>"

  Scenarios:
	|      outfit_type             | outfit_component  |
	|  classic formal look         |     jacket        |
	|  ultimate smart look         |     trousers      |
	|  business casual look        |     shirt         |
	|  contemporary formal look    |     waistcoat     |
	|  the essential weekend look  |     shoes         |


  Scenario Outline: verify I can see the "What's My Size" details in centimeters
    Given I am on a Buy The Outfit page for the "<outfit_type>" outfit
    And the currently displayed outfit component is "<outfit_component>"
    And the "<outfit_component>" Whats My Size lightbox is displayed
    And the "<outfit_component>" Whats My Size lightbox contains the measurements suitable for "<outfit_component>" in inches
    When I select View In CM
    Then the measurements in Whats My Size lightbox are displayed in centimeters

  Scenarios:
	|      outfit_type          | outfit_component  |
    |  classic formal look         |     jacket        |
    |  ultimate smart look         |     trousers      |
    |  business casual look        |     shirt         |
    |  contemporary formal look    |     waistcoat     |
    |  the essential weekend look  |     shoes         |

