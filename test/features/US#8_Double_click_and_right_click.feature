@us#8 @sinatra_mock
Feature: Support double click and right click on element
  In order to have more test options
  As a web tester
  I want to be able to execute double clicks and right clicks

  @test#119
  Scenario Outline: Double click an element
    Given I have a "<browser>" driver
    And I visit "<page>"
    And I find an element using code:
    """
    find 'h1'
    """
    And the element has text "Example Domain"
    When I double click the element
    Then no exception is raised

  @selenium_headless
    Examples:
      | browser | page                          |
      | chrome  | http://localhost:8090/example |
      | firefox | http://localhost:8090/example |

  @test#120
  Scenario Outline: Right click an element
    Given I have a "<browser>" driver
    And I visit "<page>"
    And I find an element using code:
    """
    find 'h1'
    """
    And the element has text "Example Domain"
    When I right click the element
    Then no exception is raised

  @selenium_headless
    Examples:
      | browser | page                          |
      | chrome  | http://localhost:8090/example |
      | firefox | http://localhost:8090/example |