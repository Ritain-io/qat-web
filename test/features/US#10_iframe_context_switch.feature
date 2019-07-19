@us#10 @sinatra_mock
Feature: Support iframe context switch without using code blocks
  As a Web tester
  In order to reuse Page libraries
  I want to switch to other frames without using a block

  @test#77
  Scenario Outline: Switch to iframe and back
    Given I ask for a "<driver>" driver
    When I visit "http://localhost:8090/iframe"
    Then the web page has text "Outside Frame"
    And the web page has no text "Example Domain"
    When I switch to iframe "example"
    Then the web page has no text "Outside Frame"
    And the web page has text "Example Domain"
    When I switch back from iframe
    Then the web page has text "Outside Frame"
    And the web page has no text "Example Domain"

  @selenium_headless
    Examples:
      | driver  |
      | firefox |
      | chrome  |

  @test#78
  Scenario Outline: Switch to nested iframe and back to top
    Given I ask for a "<driver>" driver
    When I visit "http://localhost:8090/nested_iframe"
    Then the web page has text "Top Frame"
    Then the web page has no text "Outside Frame"
    And the web page has no text "Example Domain"
    When I switch to iframe "nested"
    Then the web page has no text "Top Frame"
    Then the web page has text "Outside Frame"
    And the web page has no text "Example Domain"
    When I switch to iframe "example"
    Then the web page has no text "Top Frame"
    Then the web page has no text "Outside Frame"
    And the web page has text "Example Domain"
    When I switch to top frame
    Then the web page has text "Top Frame"
    Then the web page has no text "Outside Frame"
    And the web page has no text "Example Domain"

  @selenium_headless
    Examples:
      | driver  |
      | firefox |
      | chrome  |