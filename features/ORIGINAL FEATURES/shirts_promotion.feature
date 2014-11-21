Feature: Lightbox/popup detailing the special offer to buy a fifth shirt for a fixed ammount

  As a customer
  I would like to take advantage of the special offer to buy a fifth shirt for a fixed ammount
  So that I can get better value for money.


  Scenario Outline: special offer to buy a fifth shirt for a fixed ammount is triggered
    Given I am on the product item detail page for shirt "<product_item_code>" and there are already "<current_basket_total>" shirts in my basket
    When I buy "<quantity>" shirts with product item code "<product_item_code>"
    Then the offer buy a fifth shirt for "<ammount>" appears in a lightbox/popup
    And there is a link to view the shirts available in the lightbox/popup

  Scenarios:
	| quantity | product_item_code | current_basket_total |  ammount  |
	|    1     |     RG009WHT      |       3              |  25.00    |
	|    2     |     RR035BLU      |       2              |  25.00    |
	|    3     |     SN267LLC      |       1              |  25.00    |
	|    4     |     CO055BLU      |       0              |  25.00    |
	|    1     |     RR029RWH      |       3              |  25.00    |
	|    2     |     RG009WHT      |       3              |  25.00    |
	|    4     |     RR035BLU      |       3              |  25.00    |


  Scenario Outline: special offer to buy a fifth shirt for a fixed ammount is NOT triggered
    Given I am on the product item detail page for shirt "<product_item_code>" and there are already "<current_basket_total>" shirts in my basket
    When I buy "<quantity>" shirts with product item code "<product_item_code>"
    Then the offer buy a fifth shirt for "<ammount>" DOES NOT APPEAR in a lightbox/popup

  Scenarios:
	| quantity | product_item_code | current_basket_total |  ammount  |
	|    1     |     RG009WHT      |       2              |  25.00    |
	|    2     |     RR035BLU      |       1              |  25.00    |
	|    3     |     SN267LLC      |       0              |  25.00    |
	|    3     |     CO055BLU      |       0              |  25.00    |
	|    1     |     RR029RWH      |       2              |  25.00    |
