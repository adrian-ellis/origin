@ready
Feature: Verify that the required 'Telium' tags are present on each ctshirts webpage
  As a vendor
  I would like to use the 'Telium' tagging facility on each ctshirts webpage
  So that I can use the data generated to improve the collection of statistics from our customers

  Scenario Outline: 'Telium' Tags are present and correct within the Login page when I am logged in to my account
    When I log in to my account with "<email_address>" and "<password>" in country "<country_code>"
    Then the site_currency, site_region, page_name, page_type, customer_id, customer_email, campaign_source and campaign_url_code tags are present and have the expected values

  Scenarios:
    | country_code  |        email_address             |  password   |
    |      GB       |   adrian_ellis@btopenworld.com   | testing123  |
    |      US       |   adrian_ellis@btopenworld.com   | testing123  |
    |      AU       |   adrian_ellis@btopenworld.com   | testing123  |
    |      DE       |   adrian_ellis@btopenworld.com   | testing123  |

  @optional
  Scenario Outline: 'Telium' Tags are present and correct within the Home page when I am logged in to my account
    Given I log in to my account with "<email_address>" and "<password>" in country "<country_code>"
    When I navigate to the Home page
    Then the site_currency, site_region, page_name, page_type, customer_id, customer_email, campaign_source and campaign_url_code tags are present and have the expected values

  Scenarios:
    | country_code  |        email_address             |  password   |
    |      GB       |   adrian_ellis@btopenworld.com   | testing123  |
    |      US       |   adrian_ellis@btopenworld.com   | testing123  |
    |      AU       |   adrian_ellis@btopenworld.com   | testing123  |
    |      DE       |   adrian_ellis@btopenworld.com   | testing123  |

  @optional
  Scenario Outline: 'Telium' Tags are present and correct within the Search Results page when I am logged in to my account
    Given I log in to my account with "<email_address>" and "<password>" in country "<country_code>"
    When I enter the "<text>" into the Search field and submit this query
    Then the Search Results page is displayed with matches for "<text>"
    And the site_currency, site_region, page_name, page_type, customer_id, customer_email, campaign_source, campaign_url_code, product_sku and site_search_keyword tags are present and have the expected values

  Scenarios:
    | country_code  |        email_address             |  password   |      text        |
    |      GB       |   adrian_ellis@btopenworld.com   | testing123  |   slim shirt     |
    |      US       |   adrian_ellis@btopenworld.com   | testing123  |   blue shirt     |
    |      AU       |   adrian_ellis@btopenworld.com   | testing123  |   cotton shirt   |
    |      DE       |   adrian_ellis@btopenworld.com   | testing123  |   classic shirt  |

  @optional
  Scenario Outline: 'Telium' Tags are present and correct within the Search No Results page when I am logged in to my account
    Given I log in to my account with "<email_address>" and "<password>" in country "<country_code>"
    When I enter the "<text>" into the Search field and submit this query
    Then the Search No Results page is displayed with no matches for "<text>"
    And the site_currency, site_region, page_name, page_type, customer_id, customer_email, campaign_source, campaign_url_code and site_search_keyword tags are present and have the expected values

  Scenarios:
    | country_code  |        email_address             |  password   |      text        |
    |      GB       |   adrian_ellis@btopenworld.com   | testing123  |    hamster       |
    |      US       |   adrian_ellis@btopenworld.com   | testing123  |    aston martin  |
    |      AU       |   adrian_ellis@btopenworld.com   | testing123  |    roadkill      |
    |      DE       |   adrian_ellis@btopenworld.com   | testing123  |    free lunch    |

  @optional
  Scenario Outline: 'Telium' Tags are present and correct within the Product page when I am not logged in
    Given I am not logged in to my account in country "<country_code>"
    When I navigate to the product page for "<product_type>"
    Then the site_currency, site_region, page_name, page_type, campaign_source, campaign_url_code and product_sku tags are present and have the expected values

  Scenarios:
    | product_type    | country_code  |
    |   casual shirts |      GB       |
    |   casual shirts |      US       |
    |   casual shirts |      AU       |
    |   casual shirts |      DE       |

  Scenario Outline: 'Telium' Tags are present and correct within the Product page when I am logged in to my account
    Given I log in to my account with "<email_address>" and "<password>" in country "<country_code>"
      When I navigate to the product page for "<product_type>"
      Then the site_currency, site_region, page_name, page_type, customer_id, customer_email, campaign_source, campaign_url_code and product_sku tags are present and have the expected values

  Scenarios:
    | product_type    | country_code  |        email_address             |   password  |
    |   casual shirts |      GB       |   adrian_ellis@btopenworld.com   |  testing123 |
    |   casual shirts |      US       |   adrian_ellis@btopenworld.com   |  testing123 |
    |   casual shirts |      AU       |   adrian_ellis@btopenworld.com   |  testing123 |
    |   casual shirts |      DE       |   adrian_ellis@btopenworld.com   |  testing123 |

  Scenario Outline:  'Telium' Tags are present and correct within the Basket page when I am logged in, and have items in my basket
    Given I log in to my account with "<email_address>" and "<password>" in country "<country_code>"
    And I add "<qty_1>" of "<product_item_code_1>", "<qty_2>" of "<product_item_code_2>" and "<qty_3>" of "<product_item_code_3>" items to my basket
    When I am at the Basket page
    Then the site_currency, site_region, page_name, page_type, customer_id, customer_email, campaign_source, campaign_url_code, product_sku, product_name, product_unit_price and product_quantity tags are present and have the expected values

  Scenarios:
    |country_code |        email_address             |  password   | qty_1 |product_item_code_1 |qty_2 |product_item_code_2 |qty_3 | product_item_code_3 |
    |   GB        |   adrian_ellis@btopenworld.com   |  testing123 |  2    |      CW244WHT      |  1   |      CD074SKY      |  3   |      CK049GRN       |
    |   US        |   adrian_ellis@btopenworld.com   |  testing123 |  2    |      CW244WHT      |  1   |      CD074SKY      |  3   |      CK049GRN       |
    |   AU        |   adrian_ellis@btopenworld.com   |  testing123 |  2    |      CW244WHT      |  1   |      CD074SKY      |  3   |      CK049GRN       |
    |   DE        |   adrian_ellis@btopenworld.com   |  testing123 |  2    |      CW244WHT      |  1   |      CD074SKY      |  3   |      CK049GRN       |

  Scenario Outline:  'Telium' Tags are present and correct within the Order Confirmation page when I am logged in, and have items in my basket
    Given I log in to my account with "<email_address>" and "<password>" in country "<country_code>"
    And I add "<qty_1>" of "<product_item_code_1>", "<qty_2>" of "<product_item_code_2>" and "<qty_3>" of "<product_item_code_3>" items to my basket
    When I am at the Order Confirmation page
    Then the site_currency, site_region, page_name, page_type, customer_id, customer_email, customer_type, campaign_source, campaign_url_code, product_sku, product_name, order_shipping_amount, order_subtotal, order_btotal, order_id, order_shipping_type, product_unit_price and product_quantity and product_units tags are present and have the expected values

  Scenarios:
    |country_code |        email_address             |  password   | qty_1 |product_item_code_1 |qty_2 |product_item_code_2 |qty_3 | product_item_code_3 |
    |   GB        |   adrian_ellis@btopenworld.com   |  testing123 |  2    |      CW244WHT      |  1   |      CD074SKY      |  3   |      CK049GRN       |
    |   US        |   adrian_ellis@btopenworld.com   |  testing123 |  2    |      CW244WHT      |  1   |      CD074SKY      |  3   |      CK049GRN       |
    |   AU        |   adrian_ellis@btopenworld.com   |  testing123 |  2    |      CW244WHT      |  1   |      CD074SKY      |  3   |      CK049GRN       |



