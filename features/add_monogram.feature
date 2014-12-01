@monogram
Feature: Add a monogram to the shirt displayed on the product detail page
  As a customer
  I would like to add a monogram to any suitable (formal or evening) shirt displayed on the product page
  So that I can customise the clothing item that I want to buy to suit my own needs.

  Scenario Outline: verify the Add monogram lightbox appears for a suitable (formal or evening) shirt
    Given I am using the "<country>" website
    And I am on the product item detail page for a formal shirt "<product_item_code>"
    When I select Add Monogram on the product item detail page
    Then the Add monogram lightbox appears
    And the Add monogram lightbox contains selectable fields for font, colour and position and a text entry field for initials
    And the Add Monogram button appears within the Add Monogram lightbox

  Examples:
    | country | product_item_code |
    |   US    |     SN112SKY      |
    |   AU    |     FN017WHT      |
    |   GB    |     SN061WHT      |
    |   DE    |     RG049SKY      |

  Scenario Outline: Add a monogram to a suitable (formal or evening) shirt displayed on the product page
    Given I am using the "<country>" website
    And I am on the product item detail page for a formal shirt "<product_item_code>"
    And I select Add Monogram on the product item detail page
    And the Add monogram lightbox appears
    When I make a selection for "<font>", "<colour>" and "<position>" and enter text into "<initials>"
    And I click on the Add Monogram button
    Then the Add Monogram lightbox closes
    And the product item detail page is still displayed
    And the Add Monogram checkbox is checked
    And the monogram summary details for "<font>", "<colour>", "<position>" and "<initials>" are displayed next to the Add Monogram checkbox on the product item detail page

  Examples:
    | country | product_item_code |  font          | colour        | position           |  initials  |
    |   GB    |      SP043WHT     |  circle        | royal blue    | chest (left)       |    ADE     |
    |   AU    |      FC287SKY     |  Brush script  | navy          | cuff centre        |    LP12    |
    |   GB    |      SE059WHT     |  Brush script  | navy          | cuff centre        |    LP12    |
    |   US    |      SV040SKY     | sports script  | racing green  | cuff above watch   |    xGTx    |
    |   DE    |      SN439BLU     | sports script  | racing green  | cuff above watch   |    xGTx    |
    |   AU    |      SN444WHT     |  circle        | royal blue    | chest (left)       |    ADE     |


