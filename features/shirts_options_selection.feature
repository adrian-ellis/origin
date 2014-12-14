
Feature: Verify all the available shirt options can be selected
  As a customer
  I would like to be able to select from any of the available options for a shirt
  So that I can customise the shirt to meet my own needs


  Scenario Outline: verify casual shirt sizes can be selected
    Given I am using the "<country>" website
    And I am on the product item detail page for casual shirt "<product_item_code>"
    When I select Size
    And select each one of the options in turn terminating with "<final_option>"
    When I Add To Basket
    And I navigate to the Checkout
    Then the final option "<final_option>" is displayed in the item summary for "<product_item_code>"

  Scenarios:
    | country | product_item_code   | final_option |
    |   GB    |    cw245sky         |    M         |
    |   GB    |    cw245sky         |    XL        |


  Scenario Outline: verify casual shirt sizes are displayed
    Given I am using the "<country>" website
    And I am on the product item detail page for casual shirt "<product_item_code>"
    When I select Size
    Then several options are available for Size

  Scenarios:
    | country | product_item_code   |
    |   GB    |    cw245sky         |


  Scenario Outline: verify formal/evening shirt sizing options are displayed
    Given I am using the "<country>" website
    And I am on the product item detail page for a "<product_type>" with item code "<product_item_code>"
    When I select "<size_option>"
    Then several options are available for "<size_option>"

  Scenarios:
    | country |  product_type   |   product_item_code  |   size_option   |
    |   GB    |  formal shirt   |       fn017wht       |  sleeve length  |
    |   GB    |  formal shirt   |       fn017wht       |  collar size    |

	@shirts_options @allow-rescue
  Scenario Outline: verify values in second box depend on value in 1st box
    Given I am using the "<country>" website
    And I am on the product item detail page for a "<product_type>" with item code "<product_item_code>"
    When I select "<size_option_1>"
    And choose the option "<size_option_1_value>" from "<size_option_1>"
    And I select "<size_option_2>"
    Then several options are available for "<size_option_2>"

  Scenarios:
    | country |  product_type   |   product_item_code  |  size_option_1    |  size_option_1_value  |   size_option_2   |
    |   GB    |  formal shirt   |      fn017wht        |   collar size     |        15             |   sleeve length   |

  @fml_shirts_size_options
  Scenario Outline: all formal shirt sizing options can be selected
    Given I am using the "<country>" website
    And I am on the product item detail page for a "<product_type>" with item code "<product_item_code>"
    And I select "<size_option_1>"
    And choose the option "<size_option_1_value>" from "<size_option_1>"
    And I select "<size_option_2>"
    And select each one of the options for "<size_option_2>" in turn terminating with "<final_option>"
    And I Add To Basket
    When I navigate to the Checkout
    Then the option "<size_option_1_value>" and the final option "<final_option>" are displayed in the item summary for "<product_item_code>"

  Scenarios:
    | country |  product_type   |   product_item_code  |  size_option_1    |  size_option_1_value  |  size_option_2    |  final_option  |
    |   GB    |  formal shirt   |      fn017wht        |   collar size     |        16             |  sleeve length    |    34.5        |

  @fml_shirts_custom_options
  Scenario Outline: customisation on formal shirts
    Given I am using the "<country>" website
    And I am on the product item detail page for a "<product_type>" with item code "<product_item_code>"
    And I select "<size_option_1>"
    And choose the option "<size_option_1_value>" from "<size_option_1>"
    And I select "<size_option_2>"
    And choose the option "<size_option_2_value>" from "<size_option_2>"
    When I select the options "<customisation_option_1>", "<customisation_option_2>" and "<customisation_option_3>"
    And I Add To Basket
    And I navigate to the Checkout
    Then the "<customisation_option_1>", "<customisation_option_2>" and "<customisation_option_3>" options and their prices are displayed in the item summary for "<product_item_code>"

  Scenarios:
    | country |  product_type   |   product_item_code  |  size_option_1    |  size_option_1_value  |  size_option_2    | size_option_2_value |      customisation_option_1       | customisation_option_2 | customisation_option_3 |
    |   GB    |  formal shirt   |      fn017wht        |   collar size     |        16.5           |  sleeve length    |         34          |          single cuff              |       add monogram     |    add pocket          |
    |   GB    |  formal shirt   |      fn017wht        |   collar size     |        16             |  sleeve length    |         30          |          double cuff              |                        |    add pocket          |
    |   GB    |  formal shirt   |      fn017wht        |   collar size     |        16             |  sleeve length    |         34          |          add pocket               |                        |                        |
    |   GB    |  formal shirt   |      fn017wht        |   collar size     |        16             |  sleeve length    |         33.5        |          single cuff              |       add pocket       |                        |
    |   GB    |  formal shirt   |      fn017wht        |   collar size     |        16             |  sleeve length    |         34          |          double cuff              |       add pocket       |                        |
    |   GB    |  formal shirt   |      fn017wht        |   collar size     |        16             |  sleeve length    |         32.5        |          single cuff              |       add monogram     |                        |
    |   GB    |  formal shirt   |      fn017wht        |   collar size     |        16             |  sleeve length    |         33.5        |          double cuff              |       add monogram     |                        |
    |   GB    |  formal shirt   |      fn017wht        |   collar size     |        16             |  sleeve length    |         34.5        |          single cuff              |       add pocket       |       add monogram     |

	
	
	
	
	
	
