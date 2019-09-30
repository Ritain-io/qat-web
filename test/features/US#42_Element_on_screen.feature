@us#41 @sinatra_mock
Feature: Scroll element into view
  As a Web tester
  In order to check if an element is visible on screen
  I want to have a method that validates if an element is visible on screen


  @test#132
  Scenario Outline: Check if element is fully visible on screen
    Given I ask for a "<driver>" driver
    When I visit "http://localhost:8090/long_page"
    Then the image element is not on screen
    Then the element is scrolled into view
    Then the image element is fully on screen

  @selenium_headless
    Examples:
      | driver  |
      | firefox |
      | chrome  |


  @test#133
  Scenario Outline: Check if element is partially visible on screen
    Given I ask for a "<driver>" driver
    When I visit "http://localhost:8090/long_page"
    Then the image element is not on screen
    Then the element is scrolled into view
    Then the image element is partially on screen

  @selenium_headless
    Examples:
      | driver  |
      | firefox |
      | chrome  |


  @test#134
  Scenario Outline: Check if element is not visible on screen
    Given I ask for a "<driver>" driver
    When I visit "http://localhost:8090/long_page"
    Then the image element is not on screen

  @selenium_headless
    Examples:
      | driver  |
      | firefox |
      | chrome  |
