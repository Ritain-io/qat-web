@epic#199 @feature#271 @user_story#294 @selenium_headless @sinatra_mock
Feature: User Story #294: Use selector from configuration to restrict scope
  In order to restrict scope using selectors from configuration
  As a web test developer
  I want to have a wrapper to a within functionality

  @test#29
  Scenario: Access field from configuration
    Given I have a "selectors" YAML file with content:
    """
    example:
      title:
        type: xpath
        value: ./h1
      base_div:
        type: xpath
        value: /html/body/div
    """
    And I load the "selectors" YAML file with indifferent access
    And I have a "selenium" driver
    And I visit "http://localhost:8090/example"
    When I find an element using code:
    """
    within_from_configuration @yaml[:example][:base_div] do
      find_from_configuration @yaml[:example][:title]
    end
    """
    Then the element has text "Example Domain"
