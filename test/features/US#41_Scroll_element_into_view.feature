@us#41 @sinatra_mock
Feature: Scroll element into view
  As a Web tester
  In order to easily scroll elements into view
  I want to have a method to force an element to appear in a view


  @test#129
  Scenario Outline: Check if element is on screen
    Given I ask for a "<driver>" driver
    When I visit "http://localhost:8090/long_page"
    Then the title element is not on screen

  @selenium_headless
    Examples:
      | driver  |
      | firefox |
      | chrome  |


  @test#130
  Scenario Outline: Scroll element into view
    Given I ask for a "<driver>" driver
    And I visit "http://localhost:8090/long_page"
    And the title element is not on screen
    When the title element is scrolled into view
    Then the image element is partially on screen

  @selenium_headless
    Examples:
      | driver  |
      | firefox |
      | chrome  |


  @test#131
  Scenario Outline: Chaining methods with scrolling into view
    Given I ask for a "<driver>" driver
    And I visit "http://localhost:8090/long_page"
    And the title element is not on screen
    When the title element is scrolled into view and click it
    Then the image element is partially on screen

  @selenium_headless
    Examples:
      | driver  |
      | firefox |
      | chrome  |