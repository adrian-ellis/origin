Feature:
  As a user
  I would like a navigation system that allows me to view or record any currently available on demand movies
  so I can view or record any available view movies on demand at my discretion

  Scenario: On demand movies image/link is visible from the Home screen
    When I am on the Home screen
    Then the movies on demand image/link is displayed

  Scenario: text description for on demand movies screen is displayed
    Given I am on the Home screen
    When I highlight the movies on demand image/link
    Then a text description for movies on demand screen is displayed

  Scenario: Navigate to on demand movies screen from the Home screen
    Given I am on the Home screen
    When I select movies on demand
    Then the movies on demand screen is displayed

  Scenario: Access movies from TV viewing mode
    Given I am in TV viewing mode
    When I select the movies on demand shortcut
    Then the movies on demand screen is displayed



  Scenario: text description for on demand movies category is displayed
    Given I am on movies on demand screen
    When I highlight the movies on demand Categories image/link
    Then a text description for the movies on demand Categories is displayed

  Scenario: select on demand movie categories
    Given I am on movies on demand screen
    When I select the movies on demand Categories image/link
    Then the on demand movie categories screen is displayed

  Scenario: text description for Recently Added on demand movies category is displayed
    Given I am on movies on demand categories screen
    When I highlight the Recently Added movies on demand
    Then a text description for the Recently added movies on demand is displayed

  Scenario: Recently Added on demand movies category screen
    Given I am on movies on demand categories screen
    When I select the Recently Added movies on demand image/link
    Then the Recently Added on demand movies screen is displayed
    And all the required content for the Recently Added category screen is displayed



  Scenario: Browse Recently Added category
    Given I am on Recently Added on demand movies screen
    When I navigate through the Recently Added carousel
    Then all the movies within the Recently Added category are accessible

  Scenario: Description for Recently Added category
    Given I highlight one of the Recently Added movies from the Recently Added category
    Then a text description for this movie is displayed
    And other details are displayed


  Scenario: Select movie
    Given I select a movie from the Recently Added category
    Then the movie actions summary screen for this movie is displayed

  Scenario: Play movie trailer
    Given I am on the movie actions summary screen
    When I select play movie trailer
    Then the movie trailer plays back

  Scenario: Record SD movie
    Given I am on the movie actions summary screen
    When I select record SD version of movie
    Then the SD movie download starts

  Scenario: Record HD movie
    Given I am on the movie actions summary screen
    When I select record SD version of movie
    Then the HD movie download starts










