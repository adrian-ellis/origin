@inactive
Feature: View the special offer to buy a fifth shirt for a fixed ammount

  As a customer
  I would like to view the shirts available within the special offer that allows me to buy a fifth shirt for a fixed ammount
  So that I can choose a shirt and take advantage of this offer.

  Scenario Outline: 
    Given there are "<current_basket_total>" eligible shirts in my basket
    And the offer to buy a fifth shirt for "<Amount>" appears in a lightbox
    And there is a link to view the shirts available in the lightbox
    When I select View Shirts for "<Amount>" in the lightbox popup
    Then the shirt product page containing the shirts available to buy in the offer is displayed

  Scenarios: 
        | current_basket_total | Amount |
        |         4            |  25    |
