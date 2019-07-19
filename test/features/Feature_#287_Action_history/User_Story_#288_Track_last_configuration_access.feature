@epic#199 @feature#287 @user_story#288 @selenium_headless @sinatra_mock
Feature: User Story #288: Track last configuration access
  In order to have debugging context
  As a web test developer
  I want to track the last selector configuration accessed

  @test#30
  Scenario: Get the last configuration accessed
    Given I have a "selectors" YAML file with content:
    """
    example:
      title:
        type: xpath
        value: /html/body/div/h1
    """
    And I load the "selectors" YAML file with indifferent access
    And I have a "selenium" driver
    And I visit "http://localhost:8090/example"
    When I find the element from configuration "title"
    And the element has text "Example Domain"
    Then last accessed configuration is
      | type  | value             |
      | xpath | /html/body/div/h1 |


  @test#31
  Scenario: Last configuration accessed is nil at start
    Given I have a "selectors" YAML file with content:
    """
    example:
      title:
        type: xpath
        value: /html/body/div/h1
    """
    And I load the "selectors" YAML file with indifferent access
    And I have a "selenium" driver
    And I visit "http://localhost:8090/example"
    Then last accessed configuration is "nil"


  @test#32
  Scenario: Last configuration accessed is nil at start in a page context
    Given I have an "example_selectors" YAML file with content:
    """
    url: http://localhost:8090/example
    title:
      type: xpath
      value: /html/body/div/h1
    """
    And I load the "example_selectors" YAML file with indifferent access
    And I have a "selenium" driver
    When I have a Web implementation of the Example web page
    And I visit the Example web page
    Then last accessed configuration is "nil"


  @test#33
  Scenario: Get the last configuration accessed in a page context
    Given I have an "example_selectors" YAML file with content:
    """
    url: http://localhost:8090/example
    title:
      type: xpath
      value: /html/body/div/h1
    """
    And I load the "example_selectors" YAML file with indifferent access
    And I have a "selenium" driver
    When I have a Web implementation of the Example web page
    And I visit the Example web page
    And the Example page title has text "Example Domain"
    Then Example page last accessed configuration is
      | type  | value             |
      | xpath | /html/body/div/h1 |

  @test#34
  Scenario: Get the last configuration accessed per page with multiple page context
    Given I have an "example_selectors" YAML file with content:
    """
    url: http://localhost:8090/example
    title:
      type: xpath
      value: /html/body/div/h1
    """
    And I load the "example_selectors" YAML file with indifferent access
    And I have a Web implementation of the Example web page
    And I have an "gmail_selectors" YAML file with content:
    """
    url: http://localhost:8090/gmail
    title:
      type: xpath
      value: html/body/div/div/div/h1
    """
    And I load the "gmail_selectors" YAML file with indifferent access
    And I have a Web implementation of the Gmail web page
    And I have a "selenium" driver
    When I visit the Example web page
    And the Example page title has text "Example Domain"
    And I visit the Gmail web page
    And the Gmail page title has text "One account. All of Google."
    Then Example page last accessed configuration is
      | type  | value             |
      | xpath | /html/body/div/h1 |
    And Gmail page last accessed configuration is
      | type  | value                    |
      | xpath | html/body/div/div/div/h1 |
