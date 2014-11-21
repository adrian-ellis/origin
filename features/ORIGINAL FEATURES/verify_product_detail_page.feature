Feature: Verify that all the relevant information on a product detail page is present and correct
  As a customer
  I want to see all the relevant information for a clothing item on the product detail page
  So that I can assess if this clothing item is suitable for my needs

  Scenario: View product detail page
    When the product detail page loads for the following "product_type" clothing item that has "product_item_code"
      | product_type  | product_item_code  |
      | Casual shirts | CB090NAV           |
    Then the title, main_photo, thumbnail_photos, description, size_options, price, price saving information for this clothing item is displayed
    And the add_to_basket, quantity and add_to_shortlist links are displayed
