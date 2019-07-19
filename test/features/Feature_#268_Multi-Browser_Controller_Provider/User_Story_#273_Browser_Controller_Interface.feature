@epic#199 @feature#268 @user_story#273 @sinatra_mock
Feature: User Story #273: Browser Controller Interface
  In order to use various browsers
  As a web tester
  I want to have a generic browser controller interface

  @selenium_headless @test#123
  Scenario Outline: Ask for a web driver
    Given I have a "<browser>" driver
    When I visit "http://localhost:8090/example"
    Then the web page has text "Example Domain"
    Examples:
      | browser  |
      | selenium |
      | firefox  |

  @test#16
  Scenario: Ask for an unknown web driver
    When I ask for a "unknown" driver
    Then an "ArgumentError" exception is raised

  @test#17
  Scenario: Ask for a rack web driver
    Given I have a "rack_test" driver
    When I visit "/"
    Then the web page has text "Example Domain"

