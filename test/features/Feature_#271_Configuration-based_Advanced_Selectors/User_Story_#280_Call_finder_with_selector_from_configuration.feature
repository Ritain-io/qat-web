@epic#199 @feature#271 @user_story#280 @selenium_headless @sinatra_mock
Feature: User Story #280: Call finder with selector from configuration
  In order to use selectors from configuration
  As a web test developer
  I want to have a finder based on configuration input

  @test#69
  Scenario: Access field from configuration
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
    Then the element has text "Example Domain"